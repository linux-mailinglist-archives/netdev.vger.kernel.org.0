Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C056EBB7A
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 23:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjDVVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 17:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDVVZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 17:25:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D58B19BD;
        Sat, 22 Apr 2023 14:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1682198669; i=ps.report@gmx.net;
        bh=CKleXDjojnUys/EN2562bwv+uQ9gPgoHRl6X6zTBatI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Ikt9vyDBnkMF3kOLCA2mBfIh4qNPWurVhq1wy2Y61A9fpfNXeojEc3jEcXFsapCTr
         c6dOnVyWkbCQ9emiEsbsa9i8af30jeDlC7q9z93ckoOyc2KH98cJqm0d1ItqfDCCmf
         e6yTejnsc0mn3RIzghcDopivSr4jqQnIh4Dq546KacFPAdPCya9UsIS8kDG1iz8ozv
         Zt3HnekTT7deFxuFEJfBDKkYntbMAnOQNHz1uH0wr+lex+ejSGX9I7mRGabe5vEEmr
         WHwf6rIeJKZj/8wg9FHYp3j2So/0nJwAsInqVMY9JLxvkissfPzfD9p0F5OjT0quPS
         8IjUkVeKKDpAg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.fritz.box ([62.216.209.208]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MQ5rU-1pd341049I-00M0eA; Sat, 22 Apr 2023 23:24:29 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>,
        Simon Horman <simon.horman@corigine.com>,
        Peter Seiderer <ps.report@gmx.net>
Subject: [PATCH v2] wifi: ath9k: fix AR9003 mac hardware hang check register offset calculation
Date:   Sat, 22 Apr 2023 23:24:23 +0200
Message-Id: <20230422212423.26065-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:MWRn4Naaur756elw6S7aPNR3FXkqQmr1CmWuvHm3qoLXSoDxiwQ
 NUr9zv4ex4UpY0z6ePltBP0qqQQXQZ9NJDq4xDuaHqp47hwzSZuvvkp5a8aJhzw6FfT1do8
 Gx9/kmyhenxhNaKlxvcRUlACPwa+abOWwG8gPJxyiWDvfZMVct70w9GX5Vrp7FuXXDvKLE/
 mS1LHkG4FY5tUhb+eESbw==
UI-OutboundReport: notjunk:1;M01:P0:h7xOhIpkgCs=;txeLScRw9U49r2KaX2fX75E6MWC
 7d9DRRbUOktExE9V2Y5x3BEpX/gi7EI/OAZfIiN/nihj20OQCUUc3udnWPk0Iq1ryGFt0ObJ7
 vYPUkdiarBGni8zfqBHPDzGz+l9tUp8rKvqbq3CLhH/mAQmIYDC7S8wWocYc5dnXcHvuRPHMT
 eAtB58h5e/I5welvFkhvAZ3GK74e1/BZzOfXzvrojCj0Bp8Ff5jQ37tvEKAONE3QVJHD7zd+Y
 f7FV83Qo6qxdDvj310Z6ZI4gvLXKNzqYG1Fc39z3zPPr8B96hS5AI+dKuqS5WJ5IkMAKPXR72
 XKxzb5zY27eOLzPV/jzvtet6MiOVo/7NE5eYIsnMQDggcrBSMTwGv/Wpms/eTUOlJb9BIhW9F
 cPmD+lner8vd33WfSLID6w2Nqqlo3sZMrgzlbFTjvmYE8RQHlD22b1GqO1Gf0imqkIgWtyhsp
 mrIQRwmeSp5r7f0Wea4Gf1z6qDFE1hF8q38FnjFD5wdPJ2LFt4Mi9bGLNKUcQSARnFfqk1KPe
 /KOQyYqL9AEiEjftOtsQ5j7Zu4Vj4348UogPvAJuOBzMWSJnUNXoPfZ697wSMbSFXzHLjuT1h
 1bvwuv922jUTjcpEaiHnbfY7xshhdNo1N+NSPrlxL5ITnY1NpqvvGOCp47PVabqWVdmp/s9lD
 diHB8/AbqBjhW4lW/GmqYdq74PZWu4+1e1tPll+6UPqJyEKAJJ95TnqnN5HMGrOnYAy+cZuCm
 lNAUA0cLFkkvKGllVl6/van+o+KyCcgDq3mUV4RnpyHpF5g2U4Nl/ukZS8ruKNyn904tS8Ooe
 M0IAQBo9s2mOLRwQT5UDZA/FwTVJeIx5JEQhcAxYT89hnbAm9cjIYYFLPOO8y/X/2TuTWVz9c
 fA+sS4jFK9PjQbSnXMldAxGsOfnCgLgedh6d9BO7NkKa/rh5dCzWO5i2EKERUW5nKW49w5PHo
 l/2LuZPTS3wjd9BYfHyEiSFAohw=
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_BASE64_TEXT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rml4IGF0aDlrX2h3X3ZlcmlmeV9oYW5nKCkvYXI5MDAzX2h3X2RldGVjdF9tYWNfaGFuZygpIHJl
Z2lzdGVyIG9mZnNldApjYWxjdWxhdGlvbiAoZG8gbm90IG92ZXJmbG93IHRoZSBzaGlmdCBmb3Ig
dGhlIHNlY29uZCByZWdpc3Rlci9xdWV1ZXMKYWJvdmUgZml2ZSwgdXNlIHRoZSByZWdpc3RlciBs
YXlvdXQgZGVzY3JpYmVkIGluIHRoZSBjb21tZW50cyBhYm92ZQphdGg5a19od192ZXJpZnlfaGFu
ZygpIGluc3RlYWQpLgoKRml4ZXM6IDIyMmUwNDgzMGZmMCAoImF0aDlrOiBGaXggTUFDIEhXIGhh
bmcgY2hlY2sgZm9yIEFSOTAwMyIpCgpSZXBvcnRlZC1ieTogR3JlZ2cgV29uZGVybHkgPGdyZWdn
d29uZGVybHlAc2VxdGVjaGxsYy5jb20+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LXdpcmVsZXNzL0UzQTlDMzU0LTBDQjctNDIwQy1BREVGLUYwMTc3RkI3MjJGNEBzZXF0ZWNo
bGxjLmNvbS8KU2lnbmVkLW9mZi1ieTogUGV0ZXIgU2VpZGVyZXIgPHBzLnJlcG9ydEBnbXgubmV0
PgotLS0KQ2hhbmdlcyB2MSAtPiB2MjoKICAtIGZpeCBjJnAgZXJyb3IgaW4gYXRoOWtfaHdfdmVy
aWZ5X2hhbmcgKGkgdnMuIHF1ZXVlKSwgdGhhbmtzCiAgICB0byBTaW1vbiBIb3JtYW4gZm9yIHJl
dmlldwoKTm90ZXM6CiAgLSB0ZXN0ZWQgd2l0aCBNaWtyb1RpayBSMTFlLTVIbkQvQXRoZXJvcyBB
UjkzMDAgUmV2OjQgKGxzcGNpOiAxNjhjOjAwMzMKICAgIFF1YWxjb21tIEF0aGVyb3MgQVI5NTh4
IDgwMi4xMWFiZ24gV2lyZWxlc3MgTmV0d29yayBBZGFwdGVyIChyZXYgMDEpKQogICAgY2FyZAot
LS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfaHcuYyB8IDI3ICsrKysr
KysrKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA5IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9h
cjkwMDNfaHcuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfaHcuYwpp
bmRleCA0ZjI3YTlmYjE0ODIuLmU5YmQxM2VlZWU5MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDlrL2FyOTAwM19ody5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9hcjkwMDNfaHcuYwpAQCAtMTA5OSwxNyArMTA5OSwyMiBAQCBzdGF0aWMgYm9v
bCBhdGg5a19od192ZXJpZnlfaGFuZyhzdHJ1Y3QgYXRoX2h3ICphaCwgdW5zaWduZWQgaW50IHF1
ZXVlKQogewogCXUzMiBkbWFfZGJnX2NoYWluLCBkbWFfZGJnX2NvbXBsZXRlOwogCXU4IGRjdV9j
aGFpbl9zdGF0ZSwgZGN1X2NvbXBsZXRlX3N0YXRlOworCXVuc2lnbmVkIGludCBkYmdfcmVnLCBy
ZWdfb2Zmc2V0OwogCWludCBpOwogCi0JZm9yIChpID0gMDsgaSA8IE5VTV9TVEFUVVNfUkVBRFM7
IGkrKykgewotCQlpZiAocXVldWUgPCA2KQotCQkJZG1hX2RiZ19jaGFpbiA9IFJFR19SRUFEKGFo
LCBBUl9ETUFEQkdfNCk7Ci0JCWVsc2UKLQkJCWRtYV9kYmdfY2hhaW4gPSBSRUdfUkVBRChhaCwg
QVJfRE1BREJHXzUpOworCWlmIChxdWV1ZSA8IDYpIHsKKwkJZGJnX3JlZyA9IEFSX0RNQURCR180
OworCQlyZWdfb2Zmc2V0ID0gcXVldWUgKiA1OworCX0gZWxzZSB7CisJCWRiZ19yZWcgPSBBUl9E
TUFEQkdfNTsKKwkJcmVnX29mZnNldCA9IChxdWV1ZSAtIDYpICogNTsKKwl9CiAKKwlmb3IgKGkg
PSAwOyBpIDwgTlVNX1NUQVRVU19SRUFEUzsgaSsrKSB7CisJCWRtYV9kYmdfY2hhaW4gPSBSRUdf
UkVBRChhaCwgZGJnX3JlZyk7CiAJCWRtYV9kYmdfY29tcGxldGUgPSBSRUdfUkVBRChhaCwgQVJf
RE1BREJHXzYpOwogCi0JCWRjdV9jaGFpbl9zdGF0ZSA9IChkbWFfZGJnX2NoYWluID4+ICg1ICog
cXVldWUpKSAmIDB4MWY7CisJCWRjdV9jaGFpbl9zdGF0ZSA9IChkbWFfZGJnX2NoYWluID4+IHJl
Z19vZmZzZXQpICYgMHgxZjsKIAkJZGN1X2NvbXBsZXRlX3N0YXRlID0gZG1hX2RiZ19jb21wbGV0
ZSAmIDB4MzsKIAogCQlpZiAoKGRjdV9jaGFpbl9zdGF0ZSAhPSAweDYpIHx8IChkY3VfY29tcGxl
dGVfc3RhdGUgIT0gMHgxKSkKQEAgLTExMjgsNiArMTEzMyw3IEBAIHN0YXRpYyBib29sIGFyOTAw
M19od19kZXRlY3RfbWFjX2hhbmcoc3RydWN0IGF0aF9odyAqYWgpCiAJdTggZGN1X2NoYWluX3N0
YXRlLCBkY3VfY29tcGxldGVfc3RhdGU7CiAJYm9vbCBkY3Vfd2FpdF9mcmRvbmUgPSBmYWxzZTsK
IAl1bnNpZ25lZCBsb25nIGNoa19kY3UgPSAwOworCXVuc2lnbmVkIGludCByZWdfb2Zmc2V0Owog
CXVuc2lnbmVkIGludCBpID0gMDsKIAogCWRtYV9kYmdfNCA9IFJFR19SRUFEKGFoLCBBUl9ETUFE
QkdfNCk7CkBAIC0xMTM5LDEyICsxMTQ1LDE1IEBAIHN0YXRpYyBib29sIGFyOTAwM19od19kZXRl
Y3RfbWFjX2hhbmcoc3RydWN0IGF0aF9odyAqYWgpCiAJCWdvdG8gZXhpdDsKIAogCWZvciAoaSA9
IDA7IGkgPCBBVEg5S19OVU1fVFhfUVVFVUVTOyBpKyspIHsKLQkJaWYgKGkgPCA2KQorCQlpZiAo
aSA8IDYpIHsKIAkJCWNoa19kYmcgPSBkbWFfZGJnXzQ7Ci0JCWVsc2UKKwkJCXJlZ19vZmZzZXQg
PSBpICogNTsKKwkJfSBlbHNlIHsKIAkJCWNoa19kYmcgPSBkbWFfZGJnXzU7CisJCQlyZWdfb2Zm
c2V0ID0gKGkgLSA2KSAqIDU7CisJCX0KIAotCQlkY3VfY2hhaW5fc3RhdGUgPSAoY2hrX2RiZyA+
PiAoNSAqIGkpKSAmIDB4MWY7CisJCWRjdV9jaGFpbl9zdGF0ZSA9IChjaGtfZGJnID4+IHJlZ19v
ZmZzZXQpICYgMHgxZjsKIAkJaWYgKGRjdV9jaGFpbl9zdGF0ZSA9PSAweDYpIHsKIAkJCWRjdV93
YWl0X2ZyZG9uZSA9IHRydWU7CiAJCQljaGtfZGN1IHw9IEJJVChpKTsKLS0gCjIuNDAuMAoK
