Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7873863E32A
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiK3WKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiK3WJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:09:55 -0500
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95673950C4
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:09:22 -0800 (PST)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 4CB14240026
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 23:09:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1669846161; bh=pJ/6D1yVAc1MgADpZwTuHvsRf70ZbYBzpSlzp5JlyzQ=;
        h=Date:To:From:Subject:Cc:From;
        b=L0qBXTSeKPBaqUtFBnBFrNDJQY1fMP49liMbgpGKdRWxVGvTx5O6MJRYDIpBq+ObS
         n0Ys85OJyrH3eYyPNQouyvkBMW5CZmJuONGVhmq1vCl7Y1n2zyBRQGtRqSHa+zOLBQ
         aVfgezWGdl3J35xUx+a/ojYV64K6yIelFPD29fcb2FfxVRW3BmvcrhVoR8hQXduMbt
         MDvxe5RhPTJrdnzoW0o5cde5fe4YTfMMTKzLInp6YstA6iUNKDbzD7MFNKNhhjRB+A
         2JIv+5OTCjkL5Ceh1Gdk3iFKuLnYykapUk6fQWyjN2Lm4RFFw5WyMLuirOfckQ0bUb
         +lx44RXzfS6kg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4NMtf85Srkz6trZ;
        Wed, 30 Nov 2022 23:09:20 +0100 (CET)
Content-Type: multipart/mixed; boundary="------------By6oobBadPIVKwNqaAcnZ4C0"
Message-ID: <4fe84646-eef5-1a33-5451-11a7800c3c9d@posteo.de>
Date:   Wed, 30 Nov 2022 22:09:20 +0000
MIME-Version: 1.0
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   maxdev@posteo.de
Subject: [PATCH] Ensure check of nlmsg length is performed before actual
 access
Cc:     BenBE@geshi.org, github@crpykng.de
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------By6oobBadPIVKwNqaAcnZ4C0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

During a brief code review we noticed that the length field expected 
inside the payload of the message is accessed before it is ensured that 
the payload is large enough to actually hold this field.

The people mentioned in the commit message helped in the overall code 
review.

Kind regards,
Max
--------------By6oobBadPIVKwNqaAcnZ4C0
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Ensure-check-of-nlmsg-length-is-performed-before-act.patch"
Content-Disposition: attachment;
 filename*0="0001-Ensure-check-of-nlmsg-length-is-performed-before-act.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA4OTIxNmJhY2JjNDRkNjcxOTY2ODEzMjYyNmZmZDY2ODYyYmU2ZGZjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXggS3VuemVsbWFubiA8bWF4ZGV2QHBvc3Rlby5k
ZT4KRGF0ZTogV2VkLCAyMyBNYXIgMjAyMiAyMDo0Mjo1OCArMDEwMApTdWJqZWN0OiBbUEFU
Q0hdIEVuc3VyZSBjaGVjayBvZiBubG1zZyBsZW5ndGggaXMgcGVyZm9ybWVkIGJlZm9yZSBh
Y3R1YWwKIGFjY2VzcwoKUmV2aWV3ZWQtYnk6IEJlbm55IEJhdW1hbm4gPEJlbkJFQGdlc2hp
Lm9yZz4KUmV2aWV3ZWQtYnk6IFJvYmVydCBHZWlzbGluZ2VyIDxnaXRodWJAY3JweWtuZy5k
ZT4KLS0tCiBsaWIvbGlibmV0bGluay5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2xpYi9saWJuZXRs
aW5rLmMgYi9saWIvbGlibmV0bGluay5jCmluZGV4IDlhZjA2MjMyLi4wZmU3ODk0MyAxMDA2
NDQKLS0tIGEvbGliL2xpYm5ldGxpbmsuYworKysgYi9saWIvbGlibmV0bGluay5jCkBAIC03
MzIsMTMgKzczMiwxMyBAQCBpbnQgcnRubF9kdW1wX3JlcXVlc3RfbihzdHJ1Y3QgcnRubF9o
YW5kbGUgKnJ0aCwgc3RydWN0IG5sbXNnaGRyICpuKQogc3RhdGljIGludCBydG5sX2R1bXBf
ZG9uZShzdHJ1Y3Qgbmxtc2doZHIgKmgsCiAJCQkgIGNvbnN0IHN0cnVjdCBydG5sX2R1bXBf
ZmlsdGVyX2FyZyAqYSkKIHsKLQlpbnQgbGVuID0gKihpbnQgKilOTE1TR19EQVRBKGgpOwot
CiAJaWYgKGgtPm5sbXNnX2xlbiA8IE5MTVNHX0xFTkdUSChzaXplb2YoaW50KSkpIHsKIAkJ
ZnByaW50ZihzdGRlcnIsICJET05FIHRydW5jYXRlZFxuIik7CiAJCXJldHVybiAtMTsKIAl9
CiAKKwlpbnQgbGVuID0gKihpbnQgKilOTE1TR19EQVRBKGgpOworCiAJaWYgKGxlbiA8IDAp
IHsKIAkJZXJybm8gPSAtbGVuOwogCi0tIAoyLjM4LjEKCg==

--------------By6oobBadPIVKwNqaAcnZ4C0--
