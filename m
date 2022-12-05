Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D7B6423E8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiLEH5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiLEH5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:57:54 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4EE101ED
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:57:51 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id x11so12579914ljh.7
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 23:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+mjY+Aw33vNoLhNFW8eR1AS84QQXckLSL348+SjEoWA=;
        b=xCZcOwkZPfg3Uj0MJRscHTJ3VLWj6/ZAOA6mLurLh0S79Dcz2Kk5UcmbSXdzoz24lS
         yJZ3JCxY7mfS+DRWvueqoV6Ep0pL6HX9ViCuIBMsZOHHyOdLU3fYNeooX+hTWKR7OEEr
         jzRDP/GRYjE9ytVUZGXX+oUv3uTWUe/+8xW1s7wg+vpeyyTuDXKUOYJQNJS4lS/Euqpv
         6f8lzhCg5Dp1Ll143TMuEJRbWWBhaEy7RTlollOGALdzgg78Yeer0fsw0dWwUtFV491E
         S3olL1EhbrE+wzb6Cvp0tjPIEbJpqzHGaodQMgdNe3VAYNA/CuMnsDDrXPQ5GySvYTxR
         h5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mjY+Aw33vNoLhNFW8eR1AS84QQXckLSL348+SjEoWA=;
        b=NpGZ0BFq0KGkfrCc3+xI3JnnFD/WkTQqkmra4yj97x05Qv0/kzCk5mxSslB+EOgOYw
         NREkfI8u59rTwbtZihVotUawd/ipySyQJ8vFNQb20Aava8+Z3c/orl6W8Z0PVzXTRO1Z
         +X+0CWPYe1SVwo+6Il3RMr+wR1yDh7fsl5PA4AW3j9TACa9fE7JypW1Xk/u/MPrj2eP0
         xQlmP1WZTAnMxp7eXf86GGvvo4hpd+bhPUxf7mpn30CwIODqaaqOYo8NQ2gBxMLTB4vV
         weDqyNnxPhae4bkyPyEFW7qbKnh7fYWOHo4os6N1usQUZY1Z80+ZDHBBuwaSsoLvtVer
         PEYw==
X-Gm-Message-State: ANoB5pnZXpAUzi6QIVgJD9LJKdzYmXicaWBd8PyjR8ta3OiUw/TbFgHl
        /eHm0CNYGLBuhiAQpXqpQqK5DQ==
X-Google-Smtp-Source: AA0mqf7jeQcW2QaF0esimh/26E6TOXETmSNLrgMmf1UWasHde1ZnI5PqVPQR32ARJfwORw0EXyhlRQ==
X-Received: by 2002:a05:651c:179e:b0:26d:fcef:7d84 with SMTP id bn30-20020a05651c179e00b0026dfcef7d84mr21323466ljb.9.1670227069916;
        Sun, 04 Dec 2022 23:57:49 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id y12-20020a056512044c00b004b529517d95sm2033485lfk.40.2022.12.04.23.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Dec 2022 23:57:49 -0800 (PST)
Message-ID: <bc5c070e-4e9f-2bc2-ed07-788b29117143@linaro.org>
Date:   Mon, 5 Dec 2022 08:57:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING in nci_add_new_protocol
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
Cc:     syzbot <syzbot+210e196cef4711b65139@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
References: <0000000000001c590f05ee7b3ff4@google.com>
 <202212021327.FEABB55@keescook>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <202212021327.FEABB55@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2022 22:36, Kees Cook wrote:
> On Sun, Nov 27, 2022 at 02:26:30PM -0800, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    4312098baf37 Merge tag 'spi-fix-v6.1-rc6' of git://git.ker..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12e25bb5880000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=b1129081024ee340
>> dashboard link: https://syzkaller.appspot.com/bug?extid=210e196cef4711b65139
>> compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> userspace arch: arm
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+210e196cef4711b65139@syzkaller.appspotmail.com
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 7843 at net/nfc/nci/ntf.c:260 nci_add_new_protocol+0x268/0x30c net/nfc/nci/ntf.c:260
>> memcpy: detected field-spanning write (size 129) of single field "target->sensf_res" at net/nfc/nci/ntf.c:260 (size 18)
> 
> This looks like a legitimate overflow flaw to me. Likely introduced with
> commit 019c4fbaa790 ("NFC: Add NCI multiple targets support").
> 
> These appear to be explicitly filling fixed-size arrays:
> 
> struct nfc_target {
>         u32 idx;
>         u32 supported_protocols;
>         u16 sens_res;
>         u8 sel_res;
>         u8 nfcid1_len;
>         u8 nfcid1[NFC_NFCID1_MAXSIZE];
>         u8 nfcid2_len;
>         u8 nfcid2[NFC_NFCID2_MAXSIZE];
>         u8 sensb_res_len;
>         u8 sensb_res[NFC_SENSB_RES_MAXSIZE];
>         u8 sensf_res_len;
>         u8 sensf_res[NFC_SENSF_RES_MAXSIZE];
>         u8 hci_reader_gate;
>         u8 logical_idx;
>         u8 is_iso15693;
>         u8 iso15693_dsfid;
>         u8 iso15693_uid[NFC_ISO15693_UID_MAXSIZE];
> };
> 
> static int nci_add_new_protocol(..., struct nfc_target *target, ...)
> {
> 	...
>         } else if (rf_tech_and_mode == NCI_NFC_B_PASSIVE_POLL_MODE) {
>                 nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
> 
>                 target->sensb_res_len = nfcb_poll->sensb_res_len;
>                 if (target->sensb_res_len > 0) {
>                         memcpy(target->sensb_res, nfcb_poll->sensb_res,
>                                target->sensb_res_len);
>                 }
>         } else if (rf_tech_and_mode == NCI_NFC_F_PASSIVE_POLL_MODE) {
>                 nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
> 
>                 target->sensf_res_len = nfcf_poll->sensf_res_len;
>                 if (target->sensf_res_len > 0) {
>                         memcpy(target->sensf_res, nfcf_poll->sensf_res,
>                                target->sensf_res_len);
>                 }
>         } else if (rf_tech_and_mode == NCI_NFC_V_PASSIVE_POLL_MODE) {
>                 nfcv_poll = (struct rf_tech_specific_params_nfcv_poll *)params;
> 
>                 target->is_iso15693 = 1;
>                 target->iso15693_dsfid = nfcv_poll->dsfid;
>                 memcpy(target->iso15693_uid, nfcv_poll->uid, NFC_ISO15693_UID_MAXSIZE);
> 	}
> 	...
> 
> But the sizes are unbounds-checked, which means the buffers can be
> overwritten (as seen with the syzkaller report).
> 
> Perhaps this to fix it?
> 
> diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
> index 282c51051dcc..3a79f07bfea7 100644
> --- a/net/nfc/nci/ntf.c
> +++ b/net/nfc/nci/ntf.c
> @@ -240,6 +240,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
>  		target->sens_res = nfca_poll->sens_res;
>  		target->sel_res = nfca_poll->sel_res;
>  		target->nfcid1_len = nfca_poll->nfcid1_len;
> +		if (target->nfcid1_len > ARRAY_SIZE(target->target->nfcid1))
> +			return -EPROTO;

Or truncate (copy up to size of array) but both solutions look fine to me.

> 

Best regards,
Krzysztof

