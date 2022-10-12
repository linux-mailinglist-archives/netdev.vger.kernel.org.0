Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3CE5FCECA
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 01:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJLXQI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 19:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJLXQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 19:16:07 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDC81285F4
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 16:16:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id C2C63141165;
        Thu, 13 Oct 2022 01:16:01 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id I1RTkNSro_Nk; Thu, 13 Oct 2022 01:15:55 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 7C47E14112E;
        Thu, 13 Oct 2022 01:15:55 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 1F74C6138A; Thu, 13 Oct 2022 01:15:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 1AB9960FAB;
        Thu, 13 Oct 2022 01:15:55 +0200 (CEST)
Date:   Thu, 13 Oct 2022 01:15:55 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: qdisc_watchdog_schedule_range_ns granularity
In-Reply-To: <44a7e82b-0fe9-d6ba-ee12-02dfa4980966@gmail.com>
Message-ID: <a896ad54-297b-c55e-1d34-14ab26949ab6@tarent.de>
References: <c4a1d4ff-82eb-82c9-619e-37c18b41a017@tarent.de> <44a7e82b-0fe9-d6ba-ee12-02dfa4980966@gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022, Eric Dumazet wrote:

> CONFIG_HIGH_RES_TIMERS=y

It does.

> I don't know how you measure this latency, but net/sched/sch_fq.c has
> instrumentation,

On enqueue I add now+extradelay and save that as enqueue timestamp.
On dequeue I check that now>=timestamp then process the packet,
measuring now-timestamp as queue delay. This is surprisingly higher.

I’ll add some printks as well, to see when I’m called next after
such a watchdog scheduling.

> Under high cpu pressure, it is possible the softirq is delayed,
> because ksoftirqd might compete with user threads.

Is it a good idea to renice these?

Thanks,
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
