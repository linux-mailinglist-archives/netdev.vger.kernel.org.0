Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C232F21E755
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 07:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgGNFJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 01:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgGNFJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 01:09:40 -0400
X-Greylist: delayed 338 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Jul 2020 22:09:40 PDT
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73895C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 22:09:40 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4B5T250D6mzKmL1;
        Tue, 14 Jul 2020 07:03:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id QM3ymob6VDfR; Tue, 14 Jul 2020 07:03:50 +0200 (CEST)
Date:   Tue, 14 Jul 2020 15:03:40 +1000
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zbr@ioremap.net" <zbr@ioremap.net>
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
Message-ID: <20200714050340.d7llzo52exvmdubc@yavin.dot.cyphar.com>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
 <87h7uqukct.fsf@x220.int.ebiederm.org>
 <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
 <2ab92386ce5293e423aa3f117572200239a7228b.camel@alliedtelesis.co.nz>
 <87tuyb9scl.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zn6bgutiyfrzc3aq"
Content-Disposition: inline
In-Reply-To: <87tuyb9scl.fsf@x220.int.ebiederm.org>
X-MBO-SPAM-Probability: 0
X-Rspamd-Score: -7.88 / 15.00 / 15.00
X-Rspamd-Queue-Id: 721511776
X-Rspamd-UID: 662a3c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zn6bgutiyfrzc3aq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-07-13, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Matt Bennett <Matt.Bennett@alliedtelesis.co.nz> writes:
>=20
> > On Thu, 2020-07-02 at 21:10 +0200, Christian Brauner wrote:
> >> On Thu, Jul 02, 2020 at 08:17:38AM -0500, Eric W. Biederman wrote:
> >> > Matt Bennett <matt.bennett@alliedtelesis.co.nz> writes:
> >> >=20
> >> > > Previously the connector functionality could only be used by proce=
sses running in the
> >> > > default network namespace. This meant that any process that uses t=
he connector functionality
> >> > > could not operate correctly when run inside a container. This is a=
 draft patch series that
> >> > > attempts to now allow this functionality outside of the default ne=
twork namespace.
> >> > >=20
> >> > > I see this has been discussed previously [1], but am not sure how =
my changes relate to all
> >> > > of the topics discussed there and/or if there are any unintended s=
ide effects from my draft
> >> > > changes.
> >> >=20
> >> > Is there a piece of software that uses connector that you want to get
> >> > working in containers?
> >
> > We have an IPC system [1] where processes can register their socket
> > details (unix, tcp, tipc, ...) to a 'monitor' process. Processes can
> > then get notified when other processes they are interested in
> > start/stop their servers and use the registered details to connect to
> > them. Everything works unless a process crashes, in which case the
> > monitoring process never removes their details. Therefore the
> > monitoring process uses the connector functionality with
> > PROC_EVENT_EXIT to detect when a process crashes and removes the
> > details if it is a previously registered PID.
> >
> > This was working for us until we tried to run our system in a container.
> >
> >> >=20
> >> > I am curious what the motivation is because up until now there has b=
een
> >> > nothing very interesting using this functionality.  So it hasn't been
> >> > worth anyone's time to make the necessary changes to the code.
> >>=20
> >> Imho, we should just state once and for all that the proc connector wi=
ll
> >> not be namespaced. This is such a corner-case thing and has been
> >> non-namespaced for such a long time without consistent push for it to =
be
> >> namespaced combined with the fact that this needs quite some code to
> >> make it work correctly that I fear we end up buying more bugs than we'=
re
> >> selling features. And realistically, you and I will end up maintaining
> >> this and I feel this is not worth the time(?). Maybe I'm being too
> >> pessimistic though.
> >>=20
> >
> > Fair enough. I can certainly look for another way to detect process
> > crashes. Interestingly I found a patch set [2] on the mailing list
> > that attempts to solve the problem I wish to solve, but it doesn't
> > look like the patches were ever developed further. From reading the
> > discussion thread on that patch set it appears that I should be doing
> > some form of polling on the /proc files.
>=20
> Recently Christian Brauner implemented pidfd complete with a poll
> operation that reports when a process terminates.
>=20
> If you are willing to change your userspace code switching to pidfd
> should be all that you need.

While this does solve the problem of getting exit notifications in
general, you cannot get the exit code. But if they don't care about that
then we can solve that problem another time. :D

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--zn6bgutiyfrzc3aq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXw08pgAKCRCdlLljIbnQ
EnTnAQC1WMOuXTUpM9YJwsVPLrp8g3+VnICCdnIhkZvGrJlvkQEAhBVAfRLTnq80
WonHn0Nouh2x0DmG93ZjECgAmT1bAg0=
=WnVw
-----END PGP SIGNATURE-----

--zn6bgutiyfrzc3aq--
