Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CE81973A5
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgC3FCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:02:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3FCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:02:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E41D015C5C89D;
        Sun, 29 Mar 2020 22:02:42 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:02:42 -0700 (PDT)
Message-Id: <20200329.220242.1383520985415551854.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        nhorman@tuxdriver.com, lucien.xin@gmail.com,
        meng.a.jin@nokia-sbell.com
Subject: Re: [PATCH net] sctp: fix possibly using a bad saddr with a given
 dst
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d6baf212bdd7c54df847e0b5117406419c993a4f.1585182887.git.mleitner@redhat.com>
References: <d6baf212bdd7c54df847e0b5117406419c993a4f.1585182887.git.mleitner@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:02:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Mar 2020 20:47:46 -0300

> Under certain circumstances, depending on the order of addresses on the
> interfaces, it could be that sctp_v[46]_get_dst() would return a dst
> with a mismatched struct flowi.
> 
> For example, if when walking through the bind addresses and the first
> one is not a match, it saves the dst as a fallback (added in
> 410f03831c07), but not the flowi. Then if the next one is also not a
> match, the previous dst will be returned but with the flowi information
> for the 2nd address, which is wrong.
> 
> The fix is to use a locally stored flowi that can be used for such
> attempts, and copy it to the parameter only in case it is a possible
> match, together with the corresponding dst entry.
> 
> The patch updates IPv6 code mostly just to be in sync. Even though the issue
> is also present there, it fallback is not expected to work with IPv6.
> 
> Fixes: 410f03831c07 ("sctp: add routing output fallback")
> Reported-by: Jin Meng <meng.a.jin@nokia-sbell.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable.
