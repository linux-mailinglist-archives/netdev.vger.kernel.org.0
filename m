Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF414CEBF3
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 15:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiCFOey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 09:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiCFOex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 09:34:53 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85487546AC;
        Sun,  6 Mar 2022 06:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1646577238;
        bh=gj0xg4o/jelATStNvl7Ejbgin7X2OTavQUPcfcC0oOg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=rWOQ0+Od8Jzq6RvBnjveKNMh+2TMiuJNWeZIXQ/i60V95Hcn3LcbppE+z2qn/kYT4
         bbCkNG9niKu4vUi2QSZwZuKf+HePVYZ9XBidq8241PGwJBnHigQon3oR8waHNO2ikD
         flc4g5yehg4vACix+Fl6uZb7S+AJmRkR+E1DvlaY=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id CE7D7128111C;
        Sun,  6 Mar 2022 09:33:58 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ic5liuxIESJe; Sun,  6 Mar 2022 09:33:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1646577238;
        bh=gj0xg4o/jelATStNvl7Ejbgin7X2OTavQUPcfcC0oOg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=rWOQ0+Od8Jzq6RvBnjveKNMh+2TMiuJNWeZIXQ/i60V95Hcn3LcbppE+z2qn/kYT4
         bbCkNG9niKu4vUi2QSZwZuKf+HePVYZ9XBidq8241PGwJBnHigQon3oR8waHNO2ikD
         flc4g5yehg4vACix+Fl6uZb7S+AJmRkR+E1DvlaY=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B04BD12810DA;
        Sun,  6 Mar 2022 09:33:57 -0500 (EST)
Message-ID: <bf33540b3f93b32b5680ec3cab0a005b996bef5f.camel@HansenPartnership.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org
Date:   Sun, 06 Mar 2022 09:33:56 -0500
In-Reply-To: <20220303033122.10028-1-xiam0nd.tong@gmail.com>
References: <c0fc6e9c096778dce5c1e63c29af5ebdce83aca6.camel@HansenPartnership.com>
         <20220303033122.10028-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-03-03 at 11:31 +0800, Xiaomeng Tong wrote:
> On Wed, 02 Mar 2022 08:02:23 -0500, James Bottomley
> <James.Bottomley@HansenPartnership.com> wrote:
> > pos shouldn't be an input to the macro since it's being declared
> > inside
> > it.  All that will do will set up confusion about the shadowing of
> > pos.
> > The macro should still work as
> > 
> > #define list_for_each_entry_inside(type, head, member) \
> >   ...
> > 
> > For safety, you could
> > 
> > #define POS __UNIQUE_ID(pos)
> > 
> > and use POS as the loop variable .. you'll have to go through an
> > intermediate macro to get it to be stable.  There are examples in
> > linux/rcupdate.h
> 
> The outer "pos" variable is no longer needed and thus the declare
> statement before the loop is removed, see the demostration in PATCH
> 3~6. Now, there is only one inner "pos" variable left. Thus, there
> should be no such *shadow* problem.

So why is pos in the signature of your #define then?  Because that
means it expands to whatever goes in the first field of
list_for_each_entry_inside().

If someone needs to specify a unique name to avoid shadowing an
existing variable, then hide pos and use UNIQUE_ID instead was the
whole thrust of this comment.

James


