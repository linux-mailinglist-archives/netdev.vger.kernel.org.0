Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EC73C697F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 06:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhGMEqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 00:46:19 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41765 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhGMEqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 00:46:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 7B21632008FA;
        Tue, 13 Jul 2021 00:43:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 13 Jul 2021 00:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=vmxs6mKI24WNUXecEoptHIh1qYG
        OvaWRWtHD0PBgWSA=; b=nurOFU7jp1IWxaBtshahbg4jr1Gbzzz/N3SCwtrf9A/
        aqE1lRcpum7zRtot0DIrvANvEnAsfN5cjU5Kz+BRjPlJyJFKzGKXK1+wmhCQeBUt
        6OI9gKqkB1JEA1qNGgmQeKGC0245ajEZQkUVAQSFpae1mdgmJzIj++VXwvptWNoV
        P4jLsCzD+DNZ7uZujCgQ/gSjNM4wjJnCeiZzurCIM0Nx17hH+uTKW3hR4EOVdqXg
        JU6eIPVVhzMU+eHAQxqAl0WT+ZXRk1EVZCzsArRKP38Jbq8PcmOZiGwB5+OZXag1
        qbTdvLYWW5MuGQq1jyol0SlgPSsl3bcQySlHnLvdKuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vmxs6m
        KI24WNUXecEoptHIh1qYGOvaWRWtHD0PBgWSA=; b=oyAKvF6gJqdDlQTglMgLpT
        4qcMaXw1NW4eWQvv5m7L59LMmI+wzkZZxA6UH06Vje5UwPSfK5tOz8SfTozhl24x
        tWQBc1zswqDE/FMCRT0oWi5v6/8kAGU/SHvnJI+vphMhB/T/+btEgViFmfqXsdBE
        /b0f6D6fPxk5+0XceggI5IDAO8lcQFkPTqMd3qsPWpZ/r+Go8xVrD01O2yNaA6Ol
        KzCD9YL6/vnSa79Uhg5nVqeUOmS+MLnRQuNa7Tp85sLeTCbD7LVec+z8EaCY/Y+Q
        Fy8XxLDq4mjhK3I79AaRPGM7yCkJgwrWzisYBDFAlt3RZ5+k7DnrrTIOGOGbI/wQ
        ==
X-ME-Sender: <xms:8BntYIu8slazLnmjwpq0e_zoEl6j8AVn798XGnH8l8dvuow3h0sZUg>
    <xme:8BntYFdFmSGRNtFqFjOb7FOB7wa82olVd5SGP0aXFdigMHrDJi52gPTxX0IHN1rw0
    gjnGVAY2J50qw>
X-ME-Received: <xmr:8BntYDwII1go2yI5CqzWyO4VACEcE7SjxrX-7a1anre_thah7mPF2gCnL4-eeqR9JCQ3fRdSFM6vxB7SFNfzi2TOmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeggdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:8BntYLPVg-TlH1-M6DfSLz9WS4WI-siJNTnRARVD4YQIyCbrc-iBUQ>
    <xmx:8BntYI-TaDWrTbKPZ1YOXdIvB17B2HRtRxhdwR82XfshrwWHdumIbQ>
    <xmx:8BntYDXq0zyDP6Y12WQqoC3j7M5GxCFYgoi5hLCp6VRH3UZJ8dF2fA>
    <xmx:8RntYMR31BmV550b3r00CWMjQyVJBGuxe0gyKT4Nr82_AqZzy0vF-A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Jul 2021 00:43:28 -0400 (EDT)
Date:   Tue, 13 Jul 2021 06:43:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Xiaochen Zou <xzou017@ucr.edu>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Use-after-free access in j1939_session_deactivate
Message-ID: <YO0Z7s8p7CoetxdW@kroah.com>
References: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 03:40:46PM -0700, Xiaochen Zou wrote:
> Hi,
> It looks like there are multiple use-after-free accesses in
> j1939_session_deactivate()
> 
> static bool j1939_session_deactivate(struct j1939_session *session)
> {
> bool active;
> 
> j1939_session_list_lock(session->priv);
> active = j1939_session_deactivate_locked(session); //session can be freed inside
> j1939_session_list_unlock(session->priv); // It causes UAF read and write
> 
> return active;
> }
> 
> session can be freed by
> j1939_session_deactivate_locked->j1939_session_put->__j1939_session_release->j1939_session_destroy->kfree.
> Therefore it makes the unlock function perform UAF access.

Great, can you make up a patch to fix this issue so you can get credit
for finding and solving it?

thanks,

greg k-h
