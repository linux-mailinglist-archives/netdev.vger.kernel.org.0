Return-Path: <netdev+bounces-894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7FF6FB366
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E87BC280FA6
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 15:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E3B2100;
	Mon,  8 May 2023 15:05:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D480815BD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 15:05:53 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7210911A;
	Mon,  8 May 2023 08:05:51 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75773252cbfso163133185a.2;
        Mon, 08 May 2023 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683558350; x=1686150350;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LFF82DR7TBGQB+3aTSV5cEGRZpcSatHlmJ3+FnPenEc=;
        b=cPIy2yPNgE+5SW7pftnnVXM+Jrva3hS1rxvY7FUHjaSNS5mLzr5RaK/A89694sK++d
         LyGy14OpIHHXpZxuDS96gwjR0CPBMGeLlkYg9reUGQtm6QDniwL+TwHvsZaYtoyQ7RoZ
         7Lwn5xXV46XGkrMyZKhv4QheIVO4pwFjve0pimPlN7Bgstd+sU/iytNVTNgF9crDL/Wf
         g9dp6jresy6Am9Ef/ffGXuH3pSWmBC2ODDaZUo1Fkqa9dzsrnhg8zKni8szkRchCtzp3
         DHR5jT7EDo+9zXe9vr4JZrsbMeoIZFD2t9MLs+nBJ2pDE2mb9QSy80CEOwtTDIzwcG7L
         CXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683558350; x=1686150350;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LFF82DR7TBGQB+3aTSV5cEGRZpcSatHlmJ3+FnPenEc=;
        b=QNlQBCaQkrVYj3HtCxyvGCe+XQHF6z5q/oJsVIcJQt+TKS+FixOoAF2QFwv6j63ybS
         GkHEHUtBpQU4/u2GHwAocCzW0SQOJjsoxkJrBbAQPMfClUfSpNskZkKG2LqMUewAYr6c
         TuJtWqPsmpewZ91S+CA+I+n5tBlXf3thikhO4aMauZBte5o+ZvX1fRwvycuX74sSm5gq
         sDPfcYeo/OpoqIbuYL2eG4CzRaUmpCuTtmjMNRI6WIKHw57+kqG0En2zvkCupdFyPngj
         bIOgYVtIVXHTtvPOjXKrFrYyZeHSnyC0eQqRIYQyvt+DLeoXS61SoA0NJL7yTI2btIub
         HOBg==
X-Gm-Message-State: AC+VfDwzWpgVkUu+4ZwZ6O0XOJ4uFL5KClMsAC+YjEoh2afvlF21oJCe
	Z+uFzdNVz3s5abu7gLnBRbdcIWowboPXdC06nkHaYBieVB0=
X-Google-Smtp-Source: ACHHUZ6m5tmbGSkjSBJYU1CjIhfQa/2GbPGCt5Iyzg43OBzZg5yHhBdXA62WPoLxO/0Nop4OysS7r6Y7xcg6CdSm2w4=
X-Received: by 2002:ac8:5992:0:b0:3ef:3510:7c40 with SMTP id
 e18-20020ac85992000000b003ef35107c40mr16213004qte.65.1683558350442; Mon, 08
 May 2023 08:05:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Bilal Khan <bilalkhanrecovered@gmail.com>
Date: Mon, 8 May 2023 20:05:37 +0500
Message-ID: <CA++M5eJsCo8Hk5VPOJnqiaV3J5+23UANY+mg=GinncGMpA0VsA@mail.gmail.com>
Subject: [PATCH] Fix: Preserve /sys hierarchy in network namespaces
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: majordomo@vger.kernel.org, netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000701d7405fb2ff9de"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000701d7405fb2ff9de
Content-Type: text/plain; charset="UTF-8"

Dear Maintainer,

I have come across an issue with the way network namespaces are
created by ip-netns(8) in Ubuntu 18.04.4 LTS. The problem occurs when
the /sys hierarchy, particularly /sys/fs/cgroup, is not properly
mounted within network namespaces. This issue can be traced back to
the netns_switch() function in the lib/namespace.c file, where /sys is
explicitly unmounted and mounted again.

I have created a patch to fix this issue, which removes the calls to
umount2() and mount() related to the /sys filesystem in the
netns_switch() function. The patch file is named
0001-Fix-Preserve-sys-hierarchy-in-network-namespaces-by-.patch, and I
have attached it to this email.

By applying this patch, the /sys hierarchy should be preserved within
network namespaces, and the reported bug should be resolved. Please
review the patch and consider merging it into the main codebase.

Best regards,

Bilal

--000000000000701d7405fb2ff9de
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Fix-Preserve-sys-hierarchy-in-network-namespaces-by-.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-Preserve-sys-hierarchy-in-network-namespaces-by-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lhez5r990>
X-Attachment-Id: f_lhez5r990

RnJvbSBkY2I2YmU1YTk5MTFiMGRmYTBiYTljNDIwOTdjYjFmNmM1NzhiM2VlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaWxhbCBLaGFuIDxiaWxhbGtoYW5yZWNvdmVyZWRAZ21haWwu
Y29tPgpEYXRlOiBNb24sIDggTWF5IDIwMjMgMTk6MTI6MzYgKzA1MDAKU3ViamVjdDogW1BBVENI
XSBGaXg6IFByZXNlcnZlIC9zeXMgaGllcmFyY2h5IGluIG5ldHdvcmsgbmFtZXNwYWNlcyBieQog
cmVtb3ZpbmcgL3N5cyB1bm1vdW50IGFuZCBtb3VudCBjYWxscwoKU2lnbmVkLW9mZi1ieTogQmls
YWwgS2hhbiA8YmlsYWxraGFucmVjb3ZlcmVkQGdtYWlsLmNvbT4KLS0tCiBsaWIvbmFtZXNwYWNl
LmMgfCAxOCAtLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9saWIvbmFtZXNwYWNlLmMgYi9saWIvbmFtZXNwYWNlLmMKaW5kZXgg
MTIwMmZhODUuLjBmNmE1ODVmIDEwMDY0NAotLS0gYS9saWIvbmFtZXNwYWNlLmMKKysrIGIvbGli
L25hbWVzcGFjZS5jCkBAIC00Niw4ICs0Niw2IEBAIGludCBuZXRuc19zd2l0Y2goY2hhciAqbmFt
ZSkKIHsKIAljaGFyIG5ldF9wYXRoW1BBVEhfTUFYXTsKIAlpbnQgbmV0bnM7Ci0JdW5zaWduZWQg
bG9uZyBtb3VudGZsYWdzID0gMDsKLQlzdHJ1Y3Qgc3RhdHZmcyBmc3N0YXQ7CiAKIAlzbnByaW50
ZihuZXRfcGF0aCwgc2l6ZW9mKG5ldF9wYXRoKSwgIiVzLyVzIiwgTkVUTlNfUlVOX0RJUiwgbmFt
ZSk7CiAJbmV0bnMgPSBvcGVuKG5ldF9wYXRoLCBPX1JET05MWSB8IE9fQ0xPRVhFQyk7CkBAIC03
NiwyMiArNzQsNiBAQCBpbnQgbmV0bnNfc3dpdGNoKGNoYXIgKm5hbWUpCiAJCXJldHVybiAtMTsK
IAl9CiAKLQkvKiBNb3VudCBhIHZlcnNpb24gb2YgL3N5cyB0aGF0IGRlc2NyaWJlcyB0aGUgbmV0
d29yayBuYW1lc3BhY2UgKi8KLQotCWlmICh1bW91bnQyKCIvc3lzIiwgTU5UX0RFVEFDSCkgPCAw
KSB7Ci0JCS8qIElmIHRoaXMgZmFpbHMsIHBlcmhhcHMgdGhlcmUgd2Fzbid0IGEgc3lzZnMgaW5z
dGFuY2UgbW91bnRlZC4gR29vZC4gKi8KLQkJaWYgKHN0YXR2ZnMoIi9zeXMiLCAmZnNzdGF0KSA9
PSAwKSB7Ci0JCQkvKiBXZSBjb3VsZG4ndCB1bW91bnQgdGhlIHN5c2ZzLCB3ZSdsbCBhdHRlbXB0
IHRvIG92ZXJsYXkgaXQuCi0JCQkgKiBBIHJlYWQtb25seSBpbnN0YW5jZSBjYW4ndCBiZSBzaGFk
b3dlZCB3aXRoIGEgcmVhZC13cml0ZSBvbmUuICovCi0JCQlpZiAoZnNzdGF0LmZfZmxhZyAmIFNU
X1JET05MWSkKLQkJCQltb3VudGZsYWdzID0gTVNfUkRPTkxZOwotCQl9Ci0JfQotCWlmIChtb3Vu
dChuYW1lLCAiL3N5cyIsICJzeXNmcyIsIG1vdW50ZmxhZ3MsIE5VTEwpIDwgMCkgewotCQlmcHJp
bnRmKHN0ZGVyciwgIm1vdW50IG9mIC9zeXMgZmFpbGVkOiAlc1xuIixzdHJlcnJvcihlcnJubykp
OwotCQlyZXR1cm4gLTE7Ci0JfQotCiAJLyogU2V0dXAgYmluZCBtb3VudHMgZm9yIGNvbmZpZyBm
aWxlcyBpbiAvZXRjICovCiAJYmluZF9ldGMobmFtZSk7CiAJcmV0dXJuIDA7Ci0tIAoyLjI1LjEK
Cg==
--000000000000701d7405fb2ff9de--

