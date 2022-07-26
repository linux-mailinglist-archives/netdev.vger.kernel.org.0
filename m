Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1E3580C19
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiGZHEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237883AbiGZHEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:04:09 -0400
Received: from m13101.mail.163.com (m13101.mail.163.com [220.181.13.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A4472A730
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=8WO5J
        3qvYPLOBlAUHebtXbPqO7Ieal9BGEFZQAP1xHk=; b=nVT5YqUjS1O8iw0M6159B
        fb/5/6OsbDgXJ6wga57OPZocCvf622sxel+pW46+qAzr0V3SC8C9x4YAT2l4pJno
        ZAs4Lhmv1drjCTDvvzVA3V/ubWIfLupE5xAIme3XcreUSRgMY3ZNjtTKcYrEPEgo
        h4UOhuhLPzj0H+xx/2NbFc=
Received: from slark_xiao$163.com ( [223.104.68.123] ) by
 ajax-webmail-wmsvr101 (Coremail) ; Tue, 26 Jul 2022 15:02:53 +0800 (CST)
X-Originating-IP: [223.104.68.123]
Date:   Tue, 26 Jul 2022 15:02:53 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com
Cc:     netdev@vger.kernel.org
Subject: t7xx support and long term palnning
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <2564536c.449f.1823950ce01.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: ZcGowAAXPEydkd9iGudAAA--.714W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDQxKZFaEKE15zQABst
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLAogICBBcyBmYXIgYXMgSSBrbm93LCBNZWRpYVRlayB3b3VsZCByZWxlYXNlIFQ4eHgg
aW4gdGhlIGNvbWluZyBkYXlzLiAKICAgSW4gdGhlIGxhdGVzdCBrZXJuZWwsIHdlIGhhdmUgc3Vw
cG9ydHRlZCBNZWRpYVRlayBwbGF0Zm9ybSB3aXRoIG5hbWUgdDd4eHguCiAgU28gSSB3YW50IHRv
IGtub3cgaG93IHNob3VsZCB3ZSBleHRlbmQgdGhlIHN1cHBvcnQgZm9yIHQ4eHggZGV2aWNlPyBV
c2UgdGhlIHNhbWUgZHJpdmVyIHQ3eHggZm9yIGN1cnJlbnQgdDd4eCBkZXZpY2Ugb3Igd2Ugd2ls
bCBhZGQgYSBuZXcgZHJpdmVyIGZvciB0aGF0PwogIEZvciBRQyBjaGlwIG9yIEludGVsIGNoaXAs
IEkgc2F3IHRoZXkgc2hhcmVkIGEgc2FtZSBkcml2ZXIgZm9yIGRpZmZlcmVudCBwbGF0Zm9ybSwg
c3VjaCBhcyBRQyBzZHgyNCwgc2R4NTUsIHNkNjUuIEkgaG9wZSBNZWRpYVRlayBtYXkgYWxzbyB1
c2UgaXRzIHZlbmRvciBuYW1lIG9yIHNvbWV0aGluZyBlbHNlIG90aGVyIHRoYW4gYSBwcm9kdWN0
IG9yIHNlcmlhbCBuYW1lIGFzIGl0J3MgZHJpdmVyIG5hbWUuCiAgIFNvIHdoYXQncyB0aGUgcGxh
bm5pbmcgb2YgTWVkaWFUZWs/Cgo=
