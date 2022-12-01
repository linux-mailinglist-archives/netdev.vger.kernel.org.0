Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02E263EF05
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiLALJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiLALJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:09:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CE5BB7CA
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669892757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAuK7XXdRjOoP//5rJvzQeAU8adb4gJX+9CZitvvJIU=;
        b=OFq70//szQUljln7TR8Rnkq17Mqc32qoHVBJvCfUwvj3vJZmgcajak25YxS0nv9nGh1Ocr
        6os1eLT7DS9/kILD4GOuQ+Q98JwXSgTyu5dS2lA2M693yARuGNQw45Zpj9xIT7ngkoe2ip
        EOuqoEZ69WryFuO4/A2MH6G6tQVO+/I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-tI2d_JJmMf-fwb2ZTsBC3g-1; Thu, 01 Dec 2022 06:05:53 -0500
X-MC-Unique: tI2d_JJmMf-fwb2ZTsBC3g-1
Received: by mail-wm1-f72.google.com with SMTP id c26-20020a05600c0ada00b003d07fd2473bso310732wmr.9
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 03:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IAuK7XXdRjOoP//5rJvzQeAU8adb4gJX+9CZitvvJIU=;
        b=DsHCD1A2kf0I7leFiqVlWIxrs97NfeRX5ANIsONcvbejlioY7uh+fSCZ0jtxe+4m0y
         ZIsDtYMoiAUwvJdyi9M5PPPxZNXl9B+7OHnX+qIr6or5lQkAXV2lqh5tmj3lYXcSx01C
         sayDpVzGOufh7+NYykapvEw3PD0HB3N7YyV+9pU3xAFUZ9KmzAdWjg/+sT5cbAs0AwIN
         NW6fItG+7IsUcbwh+z1oMMLfAPKClJHpqHnPcdzIL6iE019m8+4zmhvGUEPui//Inbgf
         zGNPY5/9c+E0zT30XITKJXukVxfbUrXo0Q02b20O25rXjWBLdpndLY/qk9m43qKvjOzO
         S/Yw==
X-Gm-Message-State: ANoB5pnHTGERlrW5ZUjxmexFyktHuyFyFDgLRFP4mmVVt+buOk3LxGdE
        jnaVFF4SlfV+uJmrlEAaixloFSnLV1f7GXwq4WPDQUQBYUl/ZCQZ3XQXe3gsI5M/kmCcsjLeyoM
        abcvhBhOw7vNEqY47
X-Received: by 2002:a5d:4f91:0:b0:242:1847:c798 with SMTP id d17-20020a5d4f91000000b002421847c798mr11697684wru.237.1669892751433;
        Thu, 01 Dec 2022 03:05:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Ume4NGQ0XpJ4TVAdaRtMZcMj5tuE5MsrhzaEx4GhRAlWV68FbPnDWr5pjzbyBmOBMlgOcgg==
X-Received: by 2002:a5d:4f91:0:b0:242:1847:c798 with SMTP id d17-20020a5d4f91000000b002421847c798mr11697664wru.237.1669892751155;
        Thu, 01 Dec 2022 03:05:51 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id j13-20020a056000124d00b002421db5f279sm3983742wrx.78.2022.12.01.03.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:05:50 -0800 (PST)
Message-ID: <2e0a2888c89db8226578106b0a7a3eeda7c94582.camel@redhat.com>
Subject: Re: [PATCH net-next v2 0/3] net/sched: retpoline wrappers for tc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuniyu@amazon.com, Pedro Tammela <pctammela@mojatatu.com>
Date:   Thu, 01 Dec 2022 12:05:49 +0100
In-Reply-To: <20221128154456.689326-1-pctammela@mojatatu.com>
References: <20221128154456.689326-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-28 at 12:44 -0300, Pedro Tammela wrote:
> In tc all qdics, classifiers and actions can be compiled as modules.
> This results today in indirect calls in all transitions in the tc hierarchy.
> Due to CONFIG_RETPOLINE, CPUs with mitigations=on might pay an extra cost on
> indirect calls. For newer Intel cpus with IBRS the extra cost is
> nonexistent, but AMD Zen cpus and older x86 cpus still go through the
> retpoline thunk.
> 
> Known built-in symbols can be optimized into direct calls, thus
> avoiding the retpoline thunk. So far, tc has not been leveraging this
> build information and leaving out a performance optimization for some
> CPUs. In this series we wire up 'tcf_classify()' and 'tcf_action_exec()'
> with direct calls when known modules are compiled as built-in as an
> opt-in optimization.
> 
> We measured these changes in one AMD Zen 3 cpu (Retpoline), one Intel 10th
> Gen CPU (IBRS), one Intel 3rd Gen cpu (Retpoline) and one Intel Xeon CPU (IBRS)
> using pktgen with 64b udp packets. Our test setup is a dummy device with
> clsact and matchall in a kernel compiled with every tc module as built-in.
> We observed a 3-6% speed up on the retpoline CPUs, when going through 1
> tc filter, 

Do yu have all the existing filters enabled at build time in your test
kernel? the reported figures are quite higher then expected considering
there are 7th new unlikely branch in between.

Also it would be nice to have some figure for the last filter in the if
chain. I fear we could have some regressions there even for 'retpoline'
CPUs - given the long if chain - and u32 is AFAIK (not much actually)
still quite used.

Finally, it looks like the filter order in patch 1/3 is quite relevant,
and it looks like you used the lexicographic order, I guess it should
be better to sort them by 'relevance', if someone could provide a
reasonable 'relevance' order. I personally would move ife, ipt and
simple towards the bottom.

Thanks,

Paolo


