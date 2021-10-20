Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2861B43549C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhJTUbs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Oct 2021 16:31:48 -0400
Received: from lixid.tarent.de ([193.107.123.118]:51314 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhJTUbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 16:31:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 978F81410D8
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 22:29:31 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id FFK66R9UV1J7 for <netdev@vger.kernel.org>;
        Wed, 20 Oct 2021 22:29:25 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 1A3891404EB
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 22:29:25 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 8B95C1C0DFF; Wed, 20 Oct 2021 22:29:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id 88BF61C00FF
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 22:29:24 +0200 (CEST)
Date:   Wed, 20 Oct 2021 22:29:24 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: [iproute2] addattr_* vs. maxlen
Message-ID: <a56e765-479-2daa-76b8-1bb8cb5cc55a@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

(please Cc me, I’m no longer subscribed)

can please someone explain THIS (tc/q_htb.c):

	tail = addattr_nest(n, 1024, TCA_OPTIONS);

	if (rate64 >= (1ULL << 32))
		addattr_l(n, 1124, TCA_HTB_RATE64, &rate64, sizeof(rate64));

	if (ceil64 >= (1ULL << 32))
		addattr_l(n, 1224, TCA_HTB_CEIL64, &ceil64, sizeof(ceil64));

	addattr_l(n, 2024, TCA_HTB_PARMS, &opt, sizeof(opt));
	addattr_l(n, 3024, TCA_HTB_RTAB, rtab, 1024);
	addattr_l(n, 4024, TCA_HTB_CTAB, ctab, 1024);

From the reading of the libnetlink(3) manpage I’d have expected maxlen
to stay constant, and to be defined somehow near n’s allocation?

Thanks in advance,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
