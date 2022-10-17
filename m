Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48813600E7A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiJQMBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJQMA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:00:59 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F781580F
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 05:00:58 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a3so18185112wrt.0
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 05:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQjdJoe4vEi5m/yPvqEKdDmDRBjEwza9oxlp08KcxmU=;
        b=cn4w53qiJZgKdTaw35xWqNbueWk5afGvwFShqHZEDDe7QPQt3UVnjCXhfjPlWyohWU
         h7c70XCcTUqretwtT5BzikWXar2NLkVlocb1K12d+f7RncO9v5tJV3HLGH38duuZCXAi
         8T7pQnyFpovFnXIZn6RF+Rlaf2o5AQmbYPvCVUkOsnQUPh3dOBJE2TaNEdW6rithfYM6
         zNiVMaEyLbyx1m4LMPw1qXfrV/DrWM36ha3jvctUzV0QqOPFut1n5TGcIsY2EyDJnvqM
         n2ptc1VcIU+/77TEgn9WLb1X0dUNE7l7djLsCCCvLAaLz8NvQid/GxjXrtD3Eba2QBR7
         P8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQjdJoe4vEi5m/yPvqEKdDmDRBjEwza9oxlp08KcxmU=;
        b=SOs/kz6jJmaB1+Gvdwbyh9wJi49IHIdvX/rxjAiXZw2i8hce0CdivSq96nkP0Q9CQF
         pfI7KlfBFaKMrW7M+fDT1QnVg0RSkTHl3Dn72PiIl4V/0alzS9t4SOogUuyH9kuaDT2q
         8NEBZ1caRtUbRogsQraFsnmQ5YfbNf1Sb4x2iu56nnZQQNwu1JAwonSJvCpMNjrBb+BC
         tkioBfXW42JzNP+EAdjiLw2ScWRlN57jifgaqU+xQGuQDO4i7WbAVMf6t4mpwUe8GehT
         sC5JmlPgLKA5ZTQZlEuKVkENZxdalecJieQUebRcsbMSk0PFq73Fs0PhGqO7cwg5DIwF
         4sKQ==
X-Gm-Message-State: ACrzQf12UxBWyxop0tSB0T2y2zkJ8LjbgwzXXMC4agfyYc+BQfHHXCXF
        QNSMOi3Sz+SQr9KY+acOjDI=
X-Google-Smtp-Source: AMsMyM4Zv8PtKEoHHFhs4qb2XAXW21Qm3XyQehmTsj4nQmBjHCisix+DyIUw64WyP0T5Fjch8gGXpg==
X-Received: by 2002:a5d:5744:0:b0:22d:9b90:a8fe with SMTP id q4-20020a5d5744000000b0022d9b90a8femr5910097wrw.144.1666008057147;
        Mon, 17 Oct 2022 05:00:57 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id l19-20020a05600c089300b003c409244bb0sm9837270wmp.6.2022.10.17.05.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 05:00:56 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
To:     Jiri Pirko <jiri@resnulli.us>, ecree@xilinx.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        johannes@sipsolutions.net, marcelo.leitner@gmail.com
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
 <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
 <Y0gKzgmWSgw/+4Oc@nanopsycho>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <43513470-fd59-4d18-f66e-0aecfcfc8404@gmail.com>
Date:   Mon, 17 Oct 2022 13:00:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Y0gKzgmWSgw/+4Oc@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2022 13:55, Jiri Pirko wrote:
> Fri, Oct 07, 2022 at 03:25:12PM CEST, ecree@xilinx.com wrote:
>> #define NL_SET_ERR_MSG_MOD(extack, msg)			\
>> 	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
>>
>> +#define NL_SET_ERR_MSG_FMT_MOD(extack, fmt, args...)	\
> 
> I wonder, wouldn't it be better to just have NL_SET_ERR_MSG_MOD which
> accepts format string and that's it. I understand there is an extra
> overhead for the messages that don't use formatting, but do we care?
> This is no fastpath and usually happens only seldom. The API towards
> the driver would be more simple.

Could do, but this way a fixed string isn't limited to
 NETLINK_MAX_FMTMSG_LEN like it would be if we tried to stuff it
 in _msg_buf.  Unless you're suggesting some kind of macro magic
 that detects whether args is empty and chooses which
 implementation to use, but that seems like excessive hidden
 cleverness — better to have driver authors aware of the
 limitations of each choice.

> I like this a lot!
:)
