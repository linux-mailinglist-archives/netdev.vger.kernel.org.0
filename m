Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0C14D7753
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiCMRnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiCMRnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:43:49 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41C08E1A2;
        Sun, 13 Mar 2022 10:42:41 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u7so18752167ljk.13;
        Sun, 13 Mar 2022 10:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=VICepbxbcBnqYUt4eIId3oept2rRrQnAtZVabvpnL6s=;
        b=fxeqTeafhOKKuN0PGj30cOSHySlaYCvZAiOaHQ3w5xj+9AiRnuXoCUAcds3u/UO4mQ
         YvyI64QcPknjbR09YBa24ybqAY2QMIHcUh9qU9sgy+Z2iEP9jIr+NNouxV9FKL9xais7
         0EpSxzbbb63vri+9XTKXkPf4027lXuwhfNwYpsdhMbRvOXkRUCAj2rcdW6/KzVLhGgC9
         6ZL1g94exGDtP11hTf7Wy2+DBsMhS5a6PAN9XAP1rnEVeOJn46+Am4t9odwhwCsbuiO0
         5sdq8+VnihLBCs7wC/nJfxS/gUtZZznqKhLKOVbW7WyKkKY9QDADjJj/tjtWmoskGAmM
         D3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=VICepbxbcBnqYUt4eIId3oept2rRrQnAtZVabvpnL6s=;
        b=iEX/OIfih7vppu4lrSVrNH46+P/ocwEh05AF3KUuAm8gdjG19ncn2PYkvhQsSbpsXL
         ZXnaJCqMzmWeuFEKrcjf89etpsvmiSFcNSYdtWxh1m37RFI5aLYhtwJGv7D77rhV8GGJ
         TWbpCobCY4fwdgtVzWnzuVMTyQ5fDD4u0A+T2Auw+lZ/BrZCX3CVeoPq0Pxt8RwMuKK4
         ldPmjdtBEymeEr7QYayRTr95gYYGj2eTLBkiFaSOg3L0kEJCz+XWpuHzzBLeWCGOMIfx
         f78y6NNGMEJjE8+QBXLslPm96fnRk8BUz8kxw+NurOmwyCqGO41WY/+SNB1GKeDtol1R
         JVhg==
X-Gm-Message-State: AOAM532iar7zK6b9mkY6fOEiQ7rr9uMlJjJgp3RrmzjKaweH+fFi8+SA
        mpSn7FvHaWPNXpuVAG5vT3A=
X-Google-Smtp-Source: ABdhPJz6q5aLt27BntpmwIkRN+GNQ7ofbMdpOse0tAeNr0k7+DscRR6/Hcw8lUO+rHaJvpEXftsXnQ==
X-Received: by 2002:a2e:9c01:0:b0:247:e785:49cf with SMTP id s1-20020a2e9c01000000b00247e78549cfmr12343920lji.413.1647193359932;
        Sun, 13 Mar 2022 10:42:39 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id bt23-20020a056512261700b0044330517d68sm2807733lfb.191.2022.03.13.10.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 10:42:39 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------g0jKdtgL1xMR4iNPdz7Qv0gL"
Message-ID: <06e26e67-8ba0-8de7-df66-67c0b57a7dbc@gmail.com>
Date:   Sun, 13 Mar 2022 20:42:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (3)
Content-Language: en-US
To:     syzbot <syzbot+9ed16c369e0f40e366b2@syzkaller.appspotmail.com>,
        andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000d9660d05da149ac1@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000d9660d05da149ac1@google.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------g0jKdtgL1xMR4iNPdz7Qv0gL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/22 10:35, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    724946410067 x86: kmsan: enable KMSAN builds for x86
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=158dd1f6700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=28718f555f258365
> dashboard link: https://syzkaller.appspot.com/bug?extid=9ed16c369e0f40e366b2
> compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b31281700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e8c4ee700000
> 

Hm, we have closed the same bug with my patch from -next tree. Let's 
check if it really fixes the problem...

#syz test: https://github.com/google/kmsan.git master




With regards,
Pavel Skripkin
--------------g0jKdtgL1xMR4iNPdz7Qv0gL
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-asix-add-proper-error-handling-of-usb-read-error.patch"
Content-Disposition: attachment;
 filename*0="0001-net-asix-add-proper-error-handling-of-usb-read-error.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAyZTI1MGZjMDEwYTI4ODM5NjE3ODQyNjE0NzRhOGZiMjZjMTBiNjhjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBTa3JpcGtpbiA8cGFza3JpcGtpbkBnbWFp
bC5jb20+CkRhdGU6IFN1biwgNiBGZWIgMjAyMiAyMTowNToxNiArMDMwMApTdWJqZWN0OiBb
UEFUQ0hdIG5ldDogYXNpeDogYWRkIHByb3BlciBlcnJvciBoYW5kbGluZyBvZiB1c2IgcmVh
ZCBlcnJvcnMKClN5emJvdCBvbmNlIGFnYWluIGhpdCB1bmluaXQgdmFsdWUgaW4gYXNpeCBk
cml2ZXIuIFRoZSBwcm9ibGVtIHN0aWxsIHRoZQpzYW1lIC0tIGFzaXhfcmVhZF9jbWQoKSBy
ZWFkcyBsZXNzIGJ5dGVzLCB0aGFuIHdhcyByZXF1ZXN0ZWQgYnkgY2FsbGVyLgoKU2luY2Ug
YWxsIHJlYWQgcmVxdWVzdHMgYXJlIHBlcmZvcm1lZCB2aWEgYXNpeF9yZWFkX2NtZCgpIGxl
dCdzIGNhdGNoCnVzYiByZWxhdGVkIGVycm9yIHRoZXJlIGFuZCBhZGQgX19tdXN0X2NoZWNr
IG5vdGF0aW9uIHRvIGJlIHN1cmUgYWxsCmNhbGxlcnMgYWN0dWFsbHkgY2hlY2sgcmV0dXJu
IHZhbHVlLgoKU28sIHRoaXMgcGF0Y2ggYWRkcyBzYW5pdHkgY2hlY2sgaW5zaWRlIGFzaXhf
cmVhZF9jbWQoKSwgdGhhdCBzaW1wbHkKY2hlY2tzIGlmIGJ5dGVzIHJlYWQgYXJlIG5vdCBs
ZXNzLCB0aGFuIHdhcyByZXF1ZXN0ZWQgYW5kIGFkZHMgbWlzc2luZwplcnJvciBoYW5kbGlu
ZyBvZiBhc2l4X3JlYWRfY21kKCkgYWxsIGFjcm9zcyB0aGUgZHJpdmVyIGNvZGUuCgpGaXhl
czogZDlmZTY0ZTUxMTE0ICgibmV0OiBhc2l4OiBBZGQgaW5fcG0gcGFyYW1ldGVyIikKUmVw
b3J0ZWQtYW5kLXRlc3RlZC1ieTogc3l6Ym90KzZjYTlmNzg2N2I3N2MyZDMxNmFjQHN5emth
bGxlci5hcHBzcG90bWFpbC5jb20KU2lnbmVkLW9mZi1ieTogUGF2ZWwgU2tyaXBraW4gPHBh
c2tyaXBraW5AZ21haWwuY29tPgpUZXN0ZWQtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBl
bEBwZW5ndXRyb25peC5kZT4KUmV2aWV3ZWQtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3Jl
Z2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Ci0tLQogZHJpdmVycy9uZXQvdXNiL2FzaXguaCAg
ICAgICAgIHwgIDQgKystLQogZHJpdmVycy9uZXQvdXNiL2FzaXhfY29tbW9uLmMgIHwgMTkg
KysrKysrKysrKysrKy0tLS0tLQogZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5jIHwg
MjEgKysrKysrKysrKysrKysrKysrLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlv
bnMoKyksIDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9h
c2l4LmggYi9kcml2ZXJzL25ldC91c2IvYXNpeC5oCmluZGV4IDJhMWUzMWRlZmU3MS4uNDMz
NGFhZmFiNTlhIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC91c2IvYXNpeC5oCisrKyBiL2Ry
aXZlcnMvbmV0L3VzYi9hc2l4LmgKQEAgLTE5Miw4ICsxOTIsOCBAQCBleHRlcm4gY29uc3Qg
c3RydWN0IGRyaXZlcl9pbmZvIGF4ODgxNzJhX2luZm87CiAvKiBBU0lYIHNwZWNpZmljIGZs
YWdzICovCiAjZGVmaW5lIEZMQUdfRUVQUk9NX01BQwkJKDFVTCA8PCAwKSAgLyogaW5pdCBk
ZXZpY2UgTUFDIGZyb20gZWVwcm9tICovCiAKLWludCBhc2l4X3JlYWRfY21kKHN0cnVjdCB1
c2JuZXQgKmRldiwgdTggY21kLCB1MTYgdmFsdWUsIHUxNiBpbmRleCwKLQkJICB1MTYgc2l6
ZSwgdm9pZCAqZGF0YSwgaW50IGluX3BtKTsKK2ludCBfX211c3RfY2hlY2sgYXNpeF9yZWFk
X2NtZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHU4IGNtZCwgdTE2IHZhbHVlLCB1MTYgaW5kZXgs
CisJCQkgICAgICAgdTE2IHNpemUsIHZvaWQgKmRhdGEsIGludCBpbl9wbSk7CiAKIGludCBh
c2l4X3dyaXRlX2NtZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHU4IGNtZCwgdTE2IHZhbHVlLCB1
MTYgaW5kZXgsCiAJCSAgIHUxNiBzaXplLCB2b2lkICpkYXRhLCBpbnQgaW5fcG0pOwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL2FzaXhfY29tbW9uLmMgYi9kcml2ZXJzL25ldC91
c2IvYXNpeF9jb21tb24uYwppbmRleCA3MTY4Mjk3MGJlNTguLjUyNDgwNTI4NTAxOSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL2FzaXhfY29tbW9uLmMKKysrIGIvZHJpdmVycy9u
ZXQvdXNiL2FzaXhfY29tbW9uLmMKQEAgLTExLDggKzExLDggQEAKIAogI2RlZmluZSBBWF9I
T1NUX0VOX1JFVFJJRVMJMzAKIAotaW50IGFzaXhfcmVhZF9jbWQoc3RydWN0IHVzYm5ldCAq
ZGV2LCB1OCBjbWQsIHUxNiB2YWx1ZSwgdTE2IGluZGV4LAotCQkgIHUxNiBzaXplLCB2b2lk
ICpkYXRhLCBpbnQgaW5fcG0pCitpbnQgX19tdXN0X2NoZWNrIGFzaXhfcmVhZF9jbWQoc3Ry
dWN0IHVzYm5ldCAqZGV2LCB1OCBjbWQsIHUxNiB2YWx1ZSwgdTE2IGluZGV4LAorCQkJICAg
ICAgIHUxNiBzaXplLCB2b2lkICpkYXRhLCBpbnQgaW5fcG0pCiB7CiAJaW50IHJldDsKIAlp
bnQgKCpmbikoc3RydWN0IHVzYm5ldCAqLCB1OCwgdTgsIHUxNiwgdTE2LCB2b2lkICosIHUx
Nik7CkBAIC0yNyw5ICsyNywxMiBAQCBpbnQgYXNpeF9yZWFkX2NtZChzdHJ1Y3QgdXNibmV0
ICpkZXYsIHU4IGNtZCwgdTE2IHZhbHVlLCB1MTYgaW5kZXgsCiAJcmV0ID0gZm4oZGV2LCBj
bWQsIFVTQl9ESVJfSU4gfCBVU0JfVFlQRV9WRU5ET1IgfCBVU0JfUkVDSVBfREVWSUNFLAog
CQkgdmFsdWUsIGluZGV4LCBkYXRhLCBzaXplKTsKIAotCWlmICh1bmxpa2VseShyZXQgPCAw
KSkKKwlpZiAodW5saWtlbHkocmV0IDwgc2l6ZSkpIHsKKwkJcmV0ID0gcmV0IDwgMCA/IHJl
dCA6IC1FTk9EQVRBOworCiAJCW5ldGRldl93YXJuKGRldi0+bmV0LCAiRmFpbGVkIHRvIHJl
YWQgcmVnIGluZGV4IDB4JTA0eDogJWRcbiIsCiAJCQkgICAgaW5kZXgsIHJldCk7CisJfQog
CiAJcmV0dXJuIHJldDsKIH0KQEAgLTc5LDcgKzgyLDcgQEAgc3RhdGljIGludCBhc2l4X2No
ZWNrX2hvc3RfZW5hYmxlKHN0cnVjdCB1c2JuZXQgKmRldiwgaW50IGluX3BtKQogCQkJCSAg
ICAwLCAwLCAxLCAmc21zciwgaW5fcG0pOwogCQlpZiAocmV0ID09IC1FTk9ERVYpCiAJCQli
cmVhazsKLQkJZWxzZSBpZiAocmV0IDwgc2l6ZW9mKHNtc3IpKQorCQllbHNlIGlmIChyZXQg
PCAwKQogCQkJY29udGludWU7CiAJCWVsc2UgaWYgKHNtc3IgJiBBWF9IT1NUX0VOKQogCQkJ
YnJlYWs7CkBAIC01NzksOCArNTgyLDEyIEBAIGludCBhc2l4X21kaW9fcmVhZF9ub3BtKHN0
cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIGludCBwaHlfaWQsIGludCBsb2MpCiAJCXJldHVy
biByZXQ7CiAJfQogCi0JYXNpeF9yZWFkX2NtZChkZXYsIEFYX0NNRF9SRUFEX01JSV9SRUcs
IHBoeV9pZCwKLQkJICAgICAgKF9fdTE2KWxvYywgMiwgJnJlcywgMSk7CisJcmV0ID0gYXNp
eF9yZWFkX2NtZChkZXYsIEFYX0NNRF9SRUFEX01JSV9SRUcsIHBoeV9pZCwKKwkJCSAgICAo
X191MTYpbG9jLCAyLCAmcmVzLCAxKTsKKwlpZiAocmV0IDwgMCkgeworCQltdXRleF91bmxv
Y2soJmRldi0+cGh5X211dGV4KTsKKwkJcmV0dXJuIHJldDsKKwl9CiAJYXNpeF9zZXRfaHdf
bWlpKGRldiwgMSk7CiAJbXV0ZXhfdW5sb2NrKCZkZXYtPnBoeV9tdXRleCk7CiAKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9hc2l4X2RldmljZXMuYyBiL2RyaXZlcnMvbmV0L3Vz
Yi9hc2l4X2RldmljZXMuYwppbmRleCA0NTE0ZDM1ZWY0YzQuLjZiMmZiZGY0ZTBmZCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5jCisrKyBiL2RyaXZlcnMv
bmV0L3VzYi9hc2l4X2RldmljZXMuYwpAQCAtNzU1LDcgKzc1NSwxMiBAQCBzdGF0aWMgaW50
IGF4ODg3NzJfYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCB1c2JfaW50ZXJmYWNl
ICppbnRmKQogCXByaXYtPnBoeV9hZGRyID0gcmV0OwogCXByaXYtPmVtYmRfcGh5ID0gKChw
cml2LT5waHlfYWRkciAmIDB4MWYpID09IDB4MTApOwogCi0JYXNpeF9yZWFkX2NtZChkZXYs
IEFYX0NNRF9TVEFUTU5HU1RTX1JFRywgMCwgMCwgMSwgJmNoaXBjb2RlLCAwKTsKKwlyZXQg
PSBhc2l4X3JlYWRfY21kKGRldiwgQVhfQ01EX1NUQVRNTkdTVFNfUkVHLCAwLCAwLCAxLCAm
Y2hpcGNvZGUsIDApOworCWlmIChyZXQgPCAwKSB7CisJCW5ldGRldl9kYmcoZGV2LT5uZXQs
ICJGYWlsZWQgdG8gcmVhZCBTVEFUTU5HU1RTX1JFRzogJWRcbiIsIHJldCk7CisJCXJldHVy
biByZXQ7CisJfQorCiAJY2hpcGNvZGUgJj0gQVhfQ0hJUENPREVfTUFTSzsKIAogCXJldCA9
IChjaGlwY29kZSA9PSBBWF9BWDg4NzcyX0NISVBDT0RFKSA/IGF4ODg3NzJfaHdfcmVzZXQo
ZGV2LCAwKSA6CkBAIC05MjAsMTEgKzkyNSwyMSBAQCBzdGF0aWMgaW50IGF4ODgxNzhfcmVz
ZXQoc3RydWN0IHVzYm5ldCAqZGV2KQogCWludCBncGlvMCA9IDA7CiAJdTMyIHBoeWlkOwog
Ci0JYXNpeF9yZWFkX2NtZChkZXYsIEFYX0NNRF9SRUFEX0dQSU9TLCAwLCAwLCAxLCAmc3Rh
dHVzLCAwKTsKKwlyZXQgPSBhc2l4X3JlYWRfY21kKGRldiwgQVhfQ01EX1JFQURfR1BJT1Ms
IDAsIDAsIDEsICZzdGF0dXMsIDApOworCWlmIChyZXQgPCAwKSB7CisJCW5ldGRldl9kYmco
ZGV2LT5uZXQsICJGYWlsZWQgdG8gcmVhZCBHUElPUzogJWRcbiIsIHJldCk7CisJCXJldHVy
biByZXQ7CisJfQorCiAJbmV0ZGV2X2RiZyhkZXYtPm5ldCwgIkdQSU8gU3RhdHVzOiAweCUw
NHhcbiIsIHN0YXR1cyk7CiAKIAlhc2l4X3dyaXRlX2NtZChkZXYsIEFYX0NNRF9XUklURV9F
TkFCTEUsIDAsIDAsIDAsIE5VTEwsIDApOwotCWFzaXhfcmVhZF9jbWQoZGV2LCBBWF9DTURf
UkVBRF9FRVBST00sIDB4MDAxNywgMCwgMiwgJmVlcHJvbSwgMCk7CisJcmV0ID0gYXNpeF9y
ZWFkX2NtZChkZXYsIEFYX0NNRF9SRUFEX0VFUFJPTSwgMHgwMDE3LCAwLCAyLCAmZWVwcm9t
LCAwKTsKKwlpZiAocmV0IDwgMCkgeworCQluZXRkZXZfZGJnKGRldi0+bmV0LCAiRmFpbGVk
IHRvIHJlYWQgRUVQUk9NOiAlZFxuIiwgcmV0KTsKKwkJcmV0dXJuIHJldDsKKwl9CisKIAlh
c2l4X3dyaXRlX2NtZChkZXYsIEFYX0NNRF9XUklURV9ESVNBQkxFLCAwLCAwLCAwLCBOVUxM
LCAwKTsKIAogCW5ldGRldl9kYmcoZGV2LT5uZXQsICJFRVBST00gaW5kZXggMHgxNyBpcyAw
eCUwNHhcbiIsIGVlcHJvbSk7Ci0tIAoyLjM1LjEKCg==

--------------g0jKdtgL1xMR4iNPdz7Qv0gL--
