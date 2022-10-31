Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22E1613450
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJaLOj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 31 Oct 2022 07:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiJaLOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:14:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57D9E0A1
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 04:14:35 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-153-uiI169kPNS6lOD7Z8msFUQ-1; Mon, 31 Oct 2022 11:14:32 +0000
X-MC-Unique: uiI169kPNS6lOD7Z8msFUQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 31 Oct
 2022 11:14:31 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Mon, 31 Oct 2022 11:14:31 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Jiri Olsa <jolsa@kernel.org>
Subject: Linux 6.1-rc3 build fail in include/linux/bpf.h
Thread-Topic: Linux 6.1-rc3 build fail in include/linux/bpf.h
Thread-Index: AdjtGTCPbw9N9pokSJmsEaDNMnM9Hg==
Date:   Mon, 31 Oct 2022 11:14:31 +0000
Message-ID: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 6.1-rc3 sources fail to build because bpf.h unconditionally
#define BPF_DISPATCHER_ATTRIBUTES __attribute__((patchable_function_entry(5)))
for X86_64 builds.

I'm pretty sure that should depend on some other options
since the compiler isn't required to support it.
(The gcc 7.5.0 on my Ubunti 18.04 system certainly doesn't)

The only other reference to that attribute is in the definition
of 'notrace' in compiler.h.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

