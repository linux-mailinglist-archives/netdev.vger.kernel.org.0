Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8084964100F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbiLBVgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiLBVgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:36:40 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE7FEF8B5
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 13:36:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x66so6079632pfx.3
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 13:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wureQ2qHtZ8FEnEt+jaoug1YKpvv7rP1J/7SReRkYJ8=;
        b=QDIGjmAmOXPF7Ul3FS6FHx0iflkF4dMQa6d5IBEKy0f+NWJ/mYld/Kxxq+UK8Lf8f0
         hnfjuIVAUEtzd0WhDYa9+dHkhiQILUm9Eg7cnsW3khT/Px5R/DZShw4Ts+vvXCyjELY5
         YKhUChcsQsV4STCBIuD/bLL7asv0VCZ4dIW7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wureQ2qHtZ8FEnEt+jaoug1YKpvv7rP1J/7SReRkYJ8=;
        b=S20yY/UM4mVxUPeOPT8O2si14VgBGVCUsMrG3H0JPzwbKl+NQYhrpybgjkNqqD3sw4
         PP0+y80X57YbC3X9vh2+cooPaetr1vA5XaxcVz9acCv9lwQVswO6BcjBYH3p9/vd7EiN
         G5e6Blst1vo7aYWAEQBMXrJUou7f1/vwfhbaa80PAml2MneAWTCxCItDVdBZLAJfm2uE
         BxSk9+wIN7/kzwarOkYdoQ8RQEXxdcjgIpiYfWK0kucWnNysFprENYi6exMSVy5o5yH4
         XcMO3h4RdnCRDKeroHXNIw9y8I26sM/XgSsZ6YD/xkdob46IG3JykEEg5mws/Iogq1Ho
         l1Gg==
X-Gm-Message-State: ANoB5plDQvI+dbzCkRAdUQvDFrHMhZbUnQzz7s7Oc+T5NtJdm49PPqI/
        EXDRmEOyLZ4neHMiq4qkoJqi7C/yuOsCYfnj
X-Google-Smtp-Source: AA0mqf7xIkA06KJ6zAQvMBTblrXeAA8mcfDvwaXgp5RxM2ObJLfP1rkRxV2DUg8hZxWRO4VKsZ67WQ==
X-Received: by 2002:a17:902:ce90:b0:187:19c4:373a with SMTP id f16-20020a170902ce9000b0018719c4373amr66948843plg.163.1670016988822;
        Fri, 02 Dec 2022 13:36:28 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e1-20020a621e01000000b0057621a437d7sm3546989pfe.116.2022.12.02.13.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 13:36:28 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:36:27 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     syzbot <syzbot+210e196cef4711b65139@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in nci_add_new_protocol
Message-ID: <202212021327.FEABB55@keescook>
References: <0000000000001c590f05ee7b3ff4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001c590f05ee7b3ff4@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 02:26:30PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4312098baf37 Merge tag 'spi-fix-v6.1-rc6' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12e25bb5880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b1129081024ee340
> dashboard link: https://syzkaller.appspot.com/bug?extid=210e196cef4711b65139
> compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+210e196cef4711b65139@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 7843 at net/nfc/nci/ntf.c:260 nci_add_new_protocol+0x268/0x30c net/nfc/nci/ntf.c:260
> memcpy: detected field-spanning write (size 129) of single field "target->sensf_res" at net/nfc/nci/ntf.c:260 (size 18)

This looks like a legitimate overflow flaw to me. Likely introduced with
commit 019c4fbaa790 ("NFC: Add NCI multiple targets support").

These appear to be explicitly filling fixed-size arrays:

struct nfc_target {
        u32 idx;
        u32 supported_protocols;
        u16 sens_res;
        u8 sel_res;
        u8 nfcid1_len;
        u8 nfcid1[NFC_NFCID1_MAXSIZE];
        u8 nfcid2_len;
        u8 nfcid2[NFC_NFCID2_MAXSIZE];
        u8 sensb_res_len;
        u8 sensb_res[NFC_SENSB_RES_MAXSIZE];
        u8 sensf_res_len;
        u8 sensf_res[NFC_SENSF_RES_MAXSIZE];
        u8 hci_reader_gate;
        u8 logical_idx;
        u8 is_iso15693;
        u8 iso15693_dsfid;
        u8 iso15693_uid[NFC_ISO15693_UID_MAXSIZE];
};

static int nci_add_new_protocol(..., struct nfc_target *target, ...)
{
	...
        } else if (rf_tech_and_mode == NCI_NFC_B_PASSIVE_POLL_MODE) {
                nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;

                target->sensb_res_len = nfcb_poll->sensb_res_len;
                if (target->sensb_res_len > 0) {
                        memcpy(target->sensb_res, nfcb_poll->sensb_res,
                               target->sensb_res_len);
                }
        } else if (rf_tech_and_mode == NCI_NFC_F_PASSIVE_POLL_MODE) {
                nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;

                target->sensf_res_len = nfcf_poll->sensf_res_len;
                if (target->sensf_res_len > 0) {
                        memcpy(target->sensf_res, nfcf_poll->sensf_res,
                               target->sensf_res_len);
                }
        } else if (rf_tech_and_mode == NCI_NFC_V_PASSIVE_POLL_MODE) {
                nfcv_poll = (struct rf_tech_specific_params_nfcv_poll *)params;

                target->is_iso15693 = 1;
                target->iso15693_dsfid = nfcv_poll->dsfid;
                memcpy(target->iso15693_uid, nfcv_poll->uid, NFC_ISO15693_UID_MAXSIZE);
	}
	...

But the sizes are unbounds-checked, which means the buffers can be
overwritten (as seen with the syzkaller report).

Perhaps this to fix it?

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 282c51051dcc..3a79f07bfea7 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -240,6 +240,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sens_res = nfca_poll->sens_res;
 		target->sel_res = nfca_poll->sel_res;
 		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > ARRAY_SIZE(target->target->nfcid1))
+			return -EPROTO;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
 			       target->nfcid1_len);
@@ -248,6 +250,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
 
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > ARRAY_SIZE(target->sensb_res))
+			return -EPROTO;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
 			       target->sensb_res_len);
@@ -256,6 +260,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
 
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > ARRAY_SIZE(target->sensf_res))
+			return -EPROTO;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
 			       target->sensf_res_len);


-- 
Kees Cook
