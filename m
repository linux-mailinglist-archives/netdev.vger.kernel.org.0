Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC611F640
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 16:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfEOONU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 10:13:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47468 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfEOONU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 10:13:20 -0400
Received: from 24-113-124-115.wavecable.com ([24.113.124.115] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hQued-0007as-4x; Wed, 15 May 2019 10:13:15 -0400
Date:   Wed, 15 May 2019 10:12:58 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "hange-folder>?" <toggle-mailboxes@localhost.localdomain>
Subject: Re: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
Message-ID: <20190515141219.GA23839@localhost.localdomain>
References: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
 <20190509113235.GA12387@hmswarspite.think-freely.org>
 <20190509.093913.1261211226773919507.davem@davemloft.net>
 <20190510112718.GA4902@hmswarspite.think-freely.org>
 <CADvbK_f3cmHB+gcY-h6df06kMbB8eB4oiXdL7A8BvxNqVF2aJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_f3cmHB+gcY-h6df06kMbB8eB4oiXdL7A8BvxNqVF2aJw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 12, 2019 at 01:52:48PM +0800, Xin Long wrote:
> On Fri, May 10, 2019 at 7:27 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Thu, May 09, 2019 at 09:39:13AM -0700, David Miller wrote:
> > > From: Neil Horman <nhorman@tuxdriver.com>
> > > Date: Thu, 9 May 2019 07:32:35 -0400
> > >
> > > > This is definately a valid cleanup, but I wonder if it wouldn't be better to,
> > > > instead of removing it, to use it.  We have 2 locations where we actually call
> > > > sctp_make_init_ack, and then have to check the return code and abort the
> > > > operation if we get a NULL return.  Would it be a better solution (in the sense
> > > > of keeping our control flow in line with how the rest of the state machine is
> > > > supposed to work), if we didn't just add a SCTP_CMD_GEN_INIT_ACK sideeffect to
> > > > the state machine queue in the locations where we otherwise would call
> > > > sctp_make_init_ack/sctp_add_cmd_sf(...SCTP_CMD_REPLY)?
> I think they didn't do that, as the new INIT_ACK needs to add unk_param from
> the err_chunk which is allocated and freed in those two places
> sctp_sf_do_5_1B_init()/sctp_sf_do_unexpected_init().
> 
> It looks not good to pass that err_chunk as a param to the state machine.
> 
Hmm, perhaps you're right, this does look like the more clean way to do
this, even if its outside the state machine ordering

Neil

> > >
> > > Also, net-next is closed 8-)
> > >
> > Details, details :)
> >
> So everytime before posting a patch on net-next,
> I should check http://vger.kernel.org/~davem/net-next.html first, right?
> 
