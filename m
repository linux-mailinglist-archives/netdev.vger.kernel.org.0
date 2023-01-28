Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6070367F658
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbjA1IcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbjA1IcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:32:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A806D5CD
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 00:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E4ED60B37
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93172C433EF;
        Sat, 28 Jan 2023 08:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674894733;
        bh=VoEgLXqt0bzlwaRPhe5OrT/ATfoXBau3HAQCFVhtP1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=unZaIwMRg5B1kXVicb5l+uU9LIqxuiME07u+ghaSNyBr84f6ayGlJpXjbQSCQixAi
         ATJEB+Nkp42lggJfzxxVkJL+C0DQjKUPWiOaI7fLVPlkhgfXAdZxQuxKDXvYZ4K054
         PnPxOwEykjSI8RQpMrfLfvxkfx1L6zwXJIM47jwR5PKwEfiBByYc8ON6PIEY9rzvmX
         iSu8d3QuoN9rLQ2kmKwWD0iTEHmHoyVlg94D9FmQsQySR36rK0M48hrwf/JOegbrgh
         PWuzejqWqWrroLuNzOnBZDFOcVGIPKZVuGAPyeWrGJ53e0Nb308ybBrsy/uF6KpOAI
         IO07MHzUkCcPQ==
Date:   Sat, 28 Jan 2023 00:32:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com, bcodding@redhat.com,
        jlayton@redhat.com
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Message-ID: <20230128003212.7f37b45c@kernel.org>
In-Reply-To: <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
        <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 11:02:22 -0500 Chuck Lever wrote:
> I've designed a way to pass a connected kernel socket endpoint to
> user space using the traditional listen/accept mechanism. accept(2)
> gives us a well-worn building block that can materialize a connected
> socket endpoint as a file descriptor in a specific user space
> process. Like any open socket descriptor, the accepted FD can then
> be passed to a library such as GnuTLS to perform a TLS handshake.

I can't bring myself to like the new socket family layer.
I'd like a second opinion on that, if anyone within netdev
is willing to share..
