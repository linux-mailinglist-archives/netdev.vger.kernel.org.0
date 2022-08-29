Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D175A5131
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiH2QNh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Aug 2022 12:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiH2QNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:13:31 -0400
X-Greylist: delayed 4215 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 09:13:30 PDT
Received: from x61w.mirbsd.org (2001-4dd7-7451-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de [IPv6:2001:4dd7:7451:0:21f:3bff:fe0d:cbb1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1686686B5F
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 09:13:29 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id C20EA24D69; Mon, 29 Aug 2022 18:13:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id BAFF724B5E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 18:13:27 +0200 (CEST)
Date:   Mon, 29 Aug 2022 18:13:27 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: Re: inter-qdisc communication?
In-Reply-To: <CAA93jw5caRUDf1Xf+o0HV6Q1oNpTQzRKzYvCUzjXffHEf+h5Cg@mail.gmail.com>
Message-ID: <d3bfbd2-eea4-5d91-2e7e-f5b57787b4ad@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de> <20220826170632.4c975f21@kernel.org> <95259a4e-5911-6b7b-65c1-ca33312c23ec@tarent.de> <CAA93jw5caRUDf1Xf+o0HV6Q1oNpTQzRKzYvCUzjXffHEf+h5Cg@mail.gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_20,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Aug 2022, Dave Taht wrote:

> had means to do this, so did my debloat script.

OK, this basically does the same but with protocol all.

I don’t need ready-made scripts, I need building blocks
and some amount of understanding.

> > (I could just use netem but there’s still the issue of inter-
> > qdisc communication which I’d *very* much like to have, not just

This is still open… nothing? No inter-module communication possible?

Ideally, I’d configure one of the qdiscs to know the handle and device¹
of another, and then its .change op would call the .change op (or a
special function) from the other, but I lack sufficient Linux kernel
experience (even locking for SMP is something I always fear to miss).

① it really would help if just the handle is enough; they are practically
  global (in my setup) anyway because they determine the debugfs filename

Alternatively, the ability to run multiple tc commands without having to
do multiple fork/exec of the binary would help. Maybe even a “continuous”
mode, in which the binary would REPL commands from stdin, running them as
they’re read…

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
