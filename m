Return-Path: <netdev+bounces-821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B166FA1E6
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 10:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07DEE280EE5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB642154BC;
	Mon,  8 May 2023 08:05:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85F413AE2
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 08:05:15 +0000 (UTC)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7F5E61;
	Mon,  8 May 2023 01:05:14 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f386bcd858so7926771cf.0;
        Mon, 08 May 2023 01:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683533113; x=1686125113;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u4+AWsBdeTsapigTliZu2h5+/WieHsE6rUWtW6EHz9Q=;
        b=Y/rMh2wXXDwIajoCBrc57NfDp52lyHmnb8ke88JA7fCaB6jEQEOV/WyodVO/Tu0CuI
         R8FnS74zjarIUJQozu/XJPHXkBt6R7EwuW4BuYzZLpEqcbrFAXXY6nrvZvG0DnNHpfdH
         /quJB74eUnSnMoptNzUeW3cPzcUg+/53YoYe2Cbzbo5WlwBfKgi7SkNgCBWaTyBAzy7z
         U64wQsDmn7scMpbXfQBqhPe1/B6uV6ffQPg4a8LRLWZz5wJK2ysWlY6N2GPysAWDjEgd
         uBHMlkOMoFCxuFA3JsLsZcwAChO86tuRN7V9rXvNSLbVrVh3IsqUShc2ARsNw7NeloGD
         a0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683533113; x=1686125113;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u4+AWsBdeTsapigTliZu2h5+/WieHsE6rUWtW6EHz9Q=;
        b=QyLvy30Tg5Ew6C5uNpQCZmOlLNaGKXz+iPAxNA00naLqKtAuXJZePA1MCtdr3nS5EE
         lnwL/GBQhY2REw5/6a6cmEUFYJM/2uzXW5Ix0F8yPrZxOQ7Lpz28zo04au0fNI86mzyc
         KviIJBa8LSBEAihhGwNPvfLpG7P883HtwEzZ35cLpAdh9TsQqSquMn/wKjquKmGhsJ3Y
         +cSZjVZmqZUiIj7Jahspymw2poCv5niMk3bEc10QyO01lVwy16uT/w9YOvqxeW0A+0Yg
         1ldyrWivTrFsAdG7dy/uyuHd+Ud6J2qne97OdRa5dR0tuwn+fAaHLW/jyaBHU+zTonnE
         qXug==
X-Gm-Message-State: AC+VfDyjxuf15DW9SVmpbr70/3dHJtwJGzu9qcXh3W83NadHRB31ktz1
	iy/V+ZTvK0kBX/FlWDG6JI/yUz46IDL03OmKwpUT6wJJpYU=
X-Google-Smtp-Source: ACHHUZ7Q8ixWQ4lZq0wi0sk0Ual+g0a6z6zWnsceEeOmSjvH24BKPRq00VCe4f2Huuaf+EPllrkIUowymDGqS7mkZ6U=
X-Received: by 2002:a05:622a:10:b0:3e4:26de:162d with SMTP id
 x16-20020a05622a001000b003e426de162dmr14086321qtw.16.1683533113085; Mon, 08
 May 2023 01:05:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Bilal Khan <bilalkhanrecovered@gmail.com>
Date: Mon, 8 May 2023 13:05:02 +0500
Message-ID: <CA++M5eLYdY=UO2QBz17YLLw8OyG6cDYHm1dvs=mc8zQ7nPvYVA@mail.gmail.com>
Subject: [PATCH] Fix grammar in ip-rule(8) man page
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: majordomo@vger.kernel.org, netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000002c87f505fb2a19da"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000002c87f505fb2a19da
Content-Type: text/plain; charset="UTF-8"

Hey there,

I have identified a small grammatical error in the ip-rule(8) man
page, and have created a patch to fix it. The current first line of
the DESCRIPTION section reads:

> ip rule manipulates rules in the routing policy database control the route selection algorithm.

This sentence contains a grammatical error, as "control" should either
be changed to "that controls" (to apply to "database") or "to control"
(to apply to "manipulates"). I have updated the sentence to read:

> ip rule manipulates rules in the routing policy database that controls the route selection algorithm.

This change improves the readability and clarity of the ip-rule(8) man
page and makes it easier for users to understand how to use the IP
rule command.

I have attached the patch file by the name
"0001-fixed-the-grammar-in-ip-rule-8-man-page.patch" to this email and
would appreciate any feedback or suggestions for improvement.

Thank you!

--0000000000002c87f505fb2a19da
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-fixed-the-grammar-in-ip-rule-8-man-page.patch"
Content-Disposition: attachment; 
	filename="0001-fixed-the-grammar-in-ip-rule-8-man-page.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lhek3brz0>
X-Attachment-Id: f_lhek3brz0

RnJvbSAyNjIxM2I4MmI0ZDNjNWJiZTdiY2E1YWI1Mzc4YzU1ZjFlMWM5ZTc4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaWxhbCBLaGFuIDxiaWxhbGtoYW5yZWNvdmVyZWRAZ21haWwu
Y29tPgpEYXRlOiBUdWUsIDIgTWF5IDIwMjMgMTQ6NDQ6MzIgKzA1MDAKU3ViamVjdDogW1BBVENI
XSBmaXhlZCB0aGUgZ3JhbW1hciBpbiBpcC1ydWxlKDgpIG1hbiBwYWdlCgphIHNtYWxsIGdyYW1t
YXRpY2FsIGVycm9yIGhhcyBiZWVuIGlkZW5maWVkIGluIHRoZSBpcC1ydWxlKDgpIG1hbiBwYWdl
CgpTaWduZWQtb2ZmLWJ5OiBCaWxhbCBLaGFuIDxiaWxhbGtoYW5yZWNvdmVyZWRAZ21haWwuY29t
PgotLS0KIG1hbi9tYW44L2lwLXJ1bGUuOCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL21hbi9tYW44L2lwLXJ1bGUuOCBi
L21hbi9tYW44L2lwLXJ1bGUuOAppbmRleCA3NDNkODhjNi4uYzkwZDBlODcgMTAwNjQ0Ci0tLSBh
L21hbi9tYW44L2lwLXJ1bGUuOAorKysgYi9tYW4vbWFuOC9pcC1ydWxlLjgKQEAgLTg4LDcgKzg4
LDcgQEAgaXAtcnVsZSBcLSByb3V0aW5nIHBvbGljeSBkYXRhYmFzZSBtYW5hZ2VtZW50CiAuU0gg
REVTQ1JJUFRJT04KIC5JIGlwIHJ1bGUKIG1hbmlwdWxhdGVzIHJ1bGVzCi1pbiB0aGUgcm91dGlu
ZyBwb2xpY3kgZGF0YWJhc2UgY29udHJvbCB0aGUgcm91dGUgc2VsZWN0aW9uIGFsZ29yaXRobS4K
K2luIHRoZSByb3V0aW5nIHBvbGljeSBkYXRhYmFzZSB0aGF0IGNvbnRyb2xzIHRoZSByb3V0ZSBz
ZWxlY3Rpb24gYWxnb3JpdGhtLgogCiAuUAogQ2xhc3NpYyByb3V0aW5nIGFsZ29yaXRobXMgdXNl
ZCBpbiB0aGUgSW50ZXJuZXQgbWFrZSByb3V0aW5nIGRlY2lzaW9ucwotLSAKMi4yNS4xCgo=
--0000000000002c87f505fb2a19da--

