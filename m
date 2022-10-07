Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5F95F7930
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJGNqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiJGNqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:46:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E35DBCBB1
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:46:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bv10so3819461wrb.4
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 06:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DyaNYWGxzZmCesbileguZPXTP18lFvX9aGNMQS3oU1A=;
        b=Wrcfg0i/I7UEnqKRcGPK5ThqNuX/QZ4cBWB7qAm1uX20xErJUozhzo0RLCKKqiXsmt
         dSE83xQUhDpl5XAJnz+LKdrheO0g+81bYMCNHkt/MjwQVuEolR5s8jakIHcOUzy0sMeR
         pEIqMYDteuxaWqCW11MTtbHJ12j+rnSku5HOdSF4Qon0WMCoXIhQDiw/pDHXguj3d5Tn
         Gc95plaolvIQOD4lbHBMIdP9tt13r3nHGsfOh9qetwVK4re9fDMeMMggl+viHmkaIkQj
         C33/JUSuVIsadMYnwjsXVI29FOFraTSrM4F+Jt5T+9YgvfztTeQz3S7MRV8QIVkyZl2S
         UMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DyaNYWGxzZmCesbileguZPXTP18lFvX9aGNMQS3oU1A=;
        b=iCfz+ZDpUWhssQB2NGWEzcLShkVF/zNAR5EF+IByIbCryuKYCyyRD3A9QmY0Ttd6F3
         g0sGxpPL4J/HSfKQhvYS6WZidsh5jNJLDUft4pXeGijmASCCP6pYe5T3vx9+WNo/5yNh
         UIVFfelOk7HaeByWhK0O8mLN5wPuEQpWSq/sywT9niFCIdvFcX4BvLwwaaG1Kx6ZTOaU
         DZ9mhWoWyrcZr9NiDCcUdfJrmXJx2NVDBKAJMLjl2wTiX8o+AGvvxNjJ6csb6y/HcutQ
         bDiGlLKVCCjZWFzf7jIIj3w04Gwyt1C+NCNQtwbpfjXpneplKKLkEEm+RrKUWEvsuA/k
         DUVw==
X-Gm-Message-State: ACrzQf0vIVXCnNPMo6DNxXbUTkcNCe7Nn/qpD+vutUduUNxAg4pAlpqF
        +B8bo4QLyvZlBLFCNWIajUI=
X-Google-Smtp-Source: AMsMyM5KsWV3dlkIzHdZilXYD8sSB6zFTMWUMy+suS7LMv/jrDsrjbfGDtVL0lI8FmIoYRxeJ+BFqw==
X-Received: by 2002:a5d:4804:0:b0:22e:2e39:1f7c with SMTP id l4-20020a5d4804000000b0022e2e391f7cmr3149643wrq.265.1665150407839;
        Fri, 07 Oct 2022 06:46:47 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id l10-20020adfe9ca000000b002286670bafasm2096262wrn.48.2022.10.07.06.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 06:46:47 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
To:     Johannes Berg <johannes@sipsolutions.net>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        marcelo.leitner@gmail.com
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
 <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
 <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
Date:   Fri, 7 Oct 2022 14:46:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2022 14:35, Johannes Berg wrote:
> 
>> +#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {		\
>> +	struct netlink_ext_ack *__extack = (extack);		\
>> +								\
>> +	scnprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
>> +		  (fmt), ##args);				\
> 
> Maybe that should print some kind of warning if the string was longer
> than the buffer? OTOH, I guess the user would notice anyway, and until
> you run the code nobody can possibly notice ... too bad then?
> 
> Maybe we could at least _statically_ make sure that the *format* string
> (fmt) is shorter than say 60 chars or something to give some wiggle room
> for the print expansion?
> 
> 	/* allow 20 chars for format expansion */
> 	BUILD_BUG_ON(strlen(fmt) > NETLINK_MAX_FMTMSG_LEN - 20);
> 
> might even work? Just as a sanity check.

Hmm, I don't think we want to prohibit the case of (say) a 78-char format
 string with one %d that's always small-valued in practice.
In fact if you have lots of % in the format string the output could be
 significantly *shorter* than fmt.
So while I do like the idea of a sanity check, I don't see how to do it
 without imposing unnecessary limitations.

>> +	do_trace_netlink_extack(__extack->_msg_buf);		\
>> +								\
>> +	if (__extack)						\
>> +		__extack->_msg = __extack->_msg_buf;		\
> 
> That "if (__extack)" check seems a bit strange, you've long crashed with
> a NPD if it was really NULL?

Good point, I blindly copied NL_SET_ERR_MSG without thinking.
The check should enclose the whole body, will fix in v2.

-ed
