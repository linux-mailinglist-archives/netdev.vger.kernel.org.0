Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93084D3A6D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbiCITfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237228AbiCITe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:34:59 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58BA2BCF;
        Wed,  9 Mar 2022 11:33:58 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id w27so5610906lfa.5;
        Wed, 09 Mar 2022 11:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=LWE3j7gKPJN2iwgHmLsMzxFUFfpTb5xerj70IsfeOCw=;
        b=KsffXGYM9XtBqHpc1H7EhtXCK35QkjKuwE0MMkXa/4OO3SBlRvjdLkqfH47ThLXlX0
         jSjhA8xDrJ1ZVDHtPvYHGnM6ssMnY3pVT2PjZCKR2k6an+h+u1Y1z28yOiIsiMWwrUyO
         DmCpeChdMh0v6SUpH9kWg6FybrKTbmL1+GD2Vw5c3Odp4wj2/zn9tlRWsoBA54IG3uAO
         QfLAaucEgXzFcxe32zY9hfVN2KZIDPzd3hyF883MU8YweZs9U2YNo3ImUDOFIrrf6bgA
         RWqKjjyHb+0Rsv48Sail6wTtCslhWJSUEoEpntRlias0Gl0Y3ldNFBW5DElN/RBPxpMx
         h/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=LWE3j7gKPJN2iwgHmLsMzxFUFfpTb5xerj70IsfeOCw=;
        b=Emidfqu/lxPCcxZU5g/tWngVMIHtkz/vUG8leJMd3HgXB2o7nC9a/BNmSzJ9+wyY/W
         I8SACBEo8oyuwBA3KVh9bCwaV833CF3OXg3XqIlcbqFUpgJdXcHuLZwL8WM8PmhlJOt6
         dYaQBmpRf0GBFIEaZUlReTAAKoaRomvlqtrrh838wTODKANJSHufJa1VS6DC+hFHswix
         w8sErHpqtJcFw8dpSIPxo+XbxKJV98o3y3Yz040KJN1puv7r1IdRfUU5f0GuKwhzxaAZ
         /gVCfL2oSVVjlgr1olPaelfkeTG7TYy5pQVw+h5o0Y/mrg5eRigPmZcywdluCpTp1PAc
         IY6w==
X-Gm-Message-State: AOAM531kISp4FfBb6nYSOfQRpHuh5trPZOEGXLn8IiwBdV6xXTrd5DGE
        Go49EeiNFrYijiaV/E4X5oPeUaToTyc=
X-Google-Smtp-Source: ABdhPJzSdPFiI9KGYMda2XRWp6IPizyVl6+b7p9egmB3ZkYRRTxBIAx3RCGMQlkUkKfBP28nFlZe4Q==
X-Received: by 2002:ac2:5616:0:b0:445:7115:41af with SMTP id v22-20020ac25616000000b00445711541afmr735572lfd.242.1646854436892;
        Wed, 09 Mar 2022 11:33:56 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id z23-20020a2e3517000000b00247ebea6422sm601976ljz.13.2022.03.09.11.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 11:33:56 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------Fgg1wezJq9fnsbjfsArGE0th"
Message-ID: <d9addbc6-b4bd-289e-9c57-87dc9034f6a2@gmail.com>
Date:   Wed, 9 Mar 2022 22:33:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] INFO: task hung in port100_probe
Content-Language: en-US
To:     syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        krzysztof.kozlowski@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000c644cd05c55ca652@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000c644cd05c55ca652@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------Fgg1wezJq9fnsbjfsArGE0th
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/22/21 18:43, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    fd0aa1a4 Merge tag 'for-linus' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13e1500c300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
> dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1792e284300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ad9d48300000
> 


Hm, I can't reproduce this issue on top of my tree. Let's test my latest 
port100 patch

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin
--------------Fgg1wezJq9fnsbjfsArGE0th
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

Y29tbWl0IDEzMWY3ZWJiOWEzZDhkMjcxZTNiMzg0ZWVmZDY5Yjk0YzBjZmM3ODQKQXV0aG9y
OiBQYXZlbCBTa3JpcGtpbiA8cGFza3JpcGtpbkBnbWFpbC5jb20+CkRhdGU6ICAgVHVlIE1h
ciA4IDIxOjQyOjAwIDIwMjIgKzAzMDAKCiAgICBORkM6IHBvcnQxMDA6IGZpeCB1c2UtYWZ0
ZXItZnJlZSBpbiBwb3J0MTAwX3NlbmRfY29tcGxldGUKICAgIAogICAgU3l6Ym90IHJlcG9y
dGVkIFVBRiBpbiBwb3J0MTAwX3NlbmRfY29tcGxldGUoKS4gVGhlIHJvb3QgY2FzZSBpcyBp
bgogICAgbWlzc2luZyB1c2Jfa2lsbF91cmIoKSBjYWxscyBvbiBlcnJvciBoYW5kbGluZyBw
YXRoIG9mIC0+cHJvYmUgZnVuY3Rpb24uCiAgICAKICAgIHBvcnQxMDBfc2VuZF9jb21wbGV0
ZSgpIGFjY2Vzc2VzIGRldm0gYWxsb2NhdGVkIG1lbW9yeSB3aGljaCB3aWxsIGJlCiAgICBm
cmVlZCBvbiBwcm9iZSBmYWlsdXJlLiBXZSBzaG91bGQga2lsbCB0aGlzIHVyYnMgYmVmb3Jl
IHJldHVybmluZyBhbgogICAgZXJyb3IgZnJvbSBwcm9iZSBmdW5jdGlvbiB0byBwcmV2ZW50
IHJlcG9ydGVkIHVzZS1hZnRlci1mcmVlCiAgICAKICAgIEZhaWwgbG9nOgogICAgCiAgICBC
VUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbiBwb3J0MTAwX3NlbmRfY29tcGxldGUrMHgx
NmUvMHgxYTAgZHJpdmVycy9uZmMvcG9ydDEwMC5jOjkzNQogICAgUmVhZCBvZiBzaXplIDEg
YXQgYWRkciBmZmZmODg4MDFiYjU5NTQwIGJ5IHRhc2sga3NvZnRpcnFkLzIvMjYKICAgIC4u
LgogICAgQ2FsbCBUcmFjZToKICAgICA8VEFTSz4KICAgICBfX2R1bXBfc3RhY2sgbGliL2R1
bXBfc3RhY2suYzo4OCBbaW5saW5lXQogICAgIGR1bXBfc3RhY2tfbHZsKzB4Y2QvMHgxMzQg
bGliL2R1bXBfc3RhY2suYzoxMDYKICAgICBwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uLmNv
bnN0cHJvcC4wLmNvbGQrMHg4ZC8weDMwMyBtbS9rYXNhbi9yZXBvcnQuYzoyNTUKICAgICBf
X2thc2FuX3JlcG9ydCBtbS9rYXNhbi9yZXBvcnQuYzo0NDIgW2lubGluZV0KICAgICBrYXNh
bl9yZXBvcnQuY29sZCsweDgzLzB4ZGYgbW0va2FzYW4vcmVwb3J0LmM6NDU5CiAgICAgcG9y
dDEwMF9zZW5kX2NvbXBsZXRlKzB4MTZlLzB4MWEwIGRyaXZlcnMvbmZjL3BvcnQxMDAuYzo5
MzUKICAgICBfX3VzYl9oY2RfZ2l2ZWJhY2tfdXJiKzB4MmIwLzB4NWMwIGRyaXZlcnMvdXNi
L2NvcmUvaGNkLmM6MTY3MAogICAgCiAgICAuLi4KICAgIAogICAgQWxsb2NhdGVkIGJ5IHRh
c2sgMTI1NToKICAgICBrYXNhbl9zYXZlX3N0YWNrKzB4MWUvMHg0MCBtbS9rYXNhbi9jb21t
b24uYzozOAogICAgIGthc2FuX3NldF90cmFjayBtbS9rYXNhbi9jb21tb24uYzo0NSBbaW5s
aW5lXQogICAgIHNldF9hbGxvY19pbmZvIG1tL2thc2FuL2NvbW1vbi5jOjQzNiBbaW5saW5l
XQogICAgIF9fX19rYXNhbl9rbWFsbG9jIG1tL2thc2FuL2NvbW1vbi5jOjUxNSBbaW5saW5l
XQogICAgIF9fX19rYXNhbl9rbWFsbG9jIG1tL2thc2FuL2NvbW1vbi5jOjQ3NCBbaW5saW5l
XQogICAgIF9fa2FzYW5fa21hbGxvYysweGE2LzB4ZDAgbW0va2FzYW4vY29tbW9uLmM6NTI0
CiAgICAgYWxsb2NfZHIgZHJpdmVycy9iYXNlL2RldnJlcy5jOjExNiBbaW5saW5lXQogICAg
IGRldm1fa21hbGxvYysweDk2LzB4MWQwIGRyaXZlcnMvYmFzZS9kZXZyZXMuYzo4MjMKICAg
ICBkZXZtX2t6YWxsb2MgaW5jbHVkZS9saW51eC9kZXZpY2UuaDoyMDkgW2lubGluZV0KICAg
ICBwb3J0MTAwX3Byb2JlKzB4OGEvMHgxMzIwIGRyaXZlcnMvbmZjL3BvcnQxMDAuYzoxNTAy
CiAgICAKICAgIEZyZWVkIGJ5IHRhc2sgMTI1NToKICAgICBrYXNhbl9zYXZlX3N0YWNrKzB4
MWUvMHg0MCBtbS9rYXNhbi9jb21tb24uYzozOAogICAgIGthc2FuX3NldF90cmFjaysweDIx
LzB4MzAgbW0va2FzYW4vY29tbW9uLmM6NDUKICAgICBrYXNhbl9zZXRfZnJlZV9pbmZvKzB4
MjAvMHgzMCBtbS9rYXNhbi9nZW5lcmljLmM6MzcwCiAgICAgX19fX2thc2FuX3NsYWJfZnJl
ZSBtbS9rYXNhbi9jb21tb24uYzozNjYgW2lubGluZV0KICAgICBfX19fa2FzYW5fc2xhYl9m
cmVlKzB4ZmYvMHgxNDAgbW0va2FzYW4vY29tbW9uLmM6MzI4CiAgICAga2FzYW5fc2xhYl9m
cmVlIGluY2x1ZGUvbGludXgva2FzYW4uaDoyMzYgW2lubGluZV0KICAgICBfX2NhY2hlX2Zy
ZWUgbW0vc2xhYi5jOjM0MzcgW2lubGluZV0KICAgICBrZnJlZSsweGY4LzB4MmIwIG1tL3Ns
YWIuYzozNzk0CiAgICAgcmVsZWFzZV9ub2RlcysweDExMi8weDFhMCBkcml2ZXJzL2Jhc2Uv
ZGV2cmVzLmM6NTAxCiAgICAgZGV2cmVzX3JlbGVhc2VfYWxsKzB4MTE0LzB4MTkwIGRyaXZl
cnMvYmFzZS9kZXZyZXMuYzo1MzAKICAgICByZWFsbHlfcHJvYmUrMHg2MjYvMHhjYzAgZHJp
dmVycy9iYXNlL2RkLmM6NjcwCiAgICAKICAgIFJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IHN5
emJvdCsxNmJjYjEyN2ZiNzNiYWVlY2IxNEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tCiAg
ICBGaXhlczogMDM0N2E2YWIzMDBhICgiTkZDOiBwb3J0MTAwOiBDb21tYW5kcyBtZWNoYW5p
c20gaW1wbGVtZW50YXRpb24iKQogICAgU2lnbmVkLW9mZi1ieTogUGF2ZWwgU2tyaXBraW4g
PHBhc2tyaXBraW5AZ21haWwuY29tPgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmZjL3BvcnQx
MDAuYyBiL2RyaXZlcnMvbmZjL3BvcnQxMDAuYwppbmRleCBkN2RiMWEwZTZiZTEuLjAwZDhl
YTZkY2I1ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZmMvcG9ydDEwMC5jCisrKyBiL2RyaXZl
cnMvbmZjL3BvcnQxMDAuYwpAQCAtMTYxMiw3ICsxNjEyLDkgQEAgc3RhdGljIGludCBwb3J0
MTAwX3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRlcmZhY2UsCiAJbmZjX2RpZ2l0
YWxfZnJlZV9kZXZpY2UoZGV2LT5uZmNfZGlnaXRhbF9kZXYpOwogCiBlcnJvcjoKKwl1c2Jf
a2lsbF91cmIoZGV2LT5pbl91cmIpOwogCXVzYl9mcmVlX3VyYihkZXYtPmluX3VyYik7CisJ
dXNiX2tpbGxfdXJiKGRldi0+b3V0X3VyYik7CiAJdXNiX2ZyZWVfdXJiKGRldi0+b3V0X3Vy
Yik7CiAJdXNiX3B1dF9kZXYoZGV2LT51ZGV2KTsKIAo=

--------------Fgg1wezJq9fnsbjfsArGE0th--
