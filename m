Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF6180B37
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgCJWMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:12:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:42976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgCJWMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 18:12:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 28095ACC3;
        Tue, 10 Mar 2020 22:12:22 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id BE5C2E009C; Tue, 10 Mar 2020 23:12:21 +0100 (CET)
Date:   Tue, 10 Mar 2020 23:12:21 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrej Ras <kermitthekoder@gmail.com>
Subject: Re: What does this code do
Message-ID: <20200310221221.GD8012@unicorn.suse.cz>
References: <CAHfguVw9unGL-_ETLzRSVCFqHH5_etafbj1MLaMB+FywLpZjTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHfguVw9unGL-_ETLzRSVCFqHH5_etafbj1MLaMB+FywLpZjTA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 02:42:11PM -0700, Andrej Ras wrote:
> While browsing the Linux networking code I came across these two lines
> in __ip_append_data() which I do not understand.
> 
>                 /* Check if the remaining data fits into current packet. */
>                 copy = mtu - skb->len;
>                 if (copy < length)
>                         copy = maxfraglen - skb->len;
>                 if (copy <= 0) {
> 
> Why not just use maxfraglen.
> 
> Perhaps someone can explain why this is needed.

This function appends more data to an skb which can already contain some
payload. Therefore you need to take current length (from earlier) into
account, not only newly appended data.

This can be easily enforced e.g. with TCP_CORK or UDP_CORK socket option
or MSG_MORE flag.

Michal Kubecek
