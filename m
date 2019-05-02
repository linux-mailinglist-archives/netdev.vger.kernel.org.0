Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C229123B9
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfEBU5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:57:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:24945 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfEBU5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 16:57:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 13:57:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,423,1549958400"; 
   d="asc'?scan'208";a="147682562"
Received: from vbhyrapu-mobl.amr.corp.intel.com ([10.252.138.72])
  by orsmga003.jf.intel.com with ESMTP; 02 May 2019 13:57:34 -0700
Message-ID: <59cb8e4f8bb6c6e49b616362dfbd211a2b0d560a.camel@intel.com>
Subject: Re: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Thu, 02 May 2019 13:57:34 -0700
In-Reply-To: <7d5c0e5b-873d-55be-10c4-bc3af657f978@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
         <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
         <806f5242-d509-e015-275e-ad0325f17222@iogearbox.net>
         <0c73af48-d638-dd58-fcf8-c872ff8591d7@intel.com>
         <5e546c17ad929d97d6c4ca7d93b8f504da33dc31.camel@intel.com>
         <7d5c0e5b-873d-55be-10c4-bc3af657f978@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Qk5v+lMLUVRq2VE/2Gvc"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-Qk5v+lMLUVRq2VE/2Gvc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-05-02 at 22:56 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> On 2019-05-02 22:40, Jeff Kirsher wrote:
> > On Thu, 2019-05-02 at 22:29 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > > On 2019-05-02 16:47, Daniel Borkmann wrote:
> > > > On 04/29/2019 09:16 PM, Jeff Kirsher wrote:
> > > > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > > > >=20
> > > > > GCC will generate jump tables for switch-statements with more
> > > > > than 5
> > > > > case statements. An entry into the jump table is an indirect
> > > > > call,
> > > > > which means that for CONFIG_RETPOLINE builds, this is rather
> > > > > expensive.
> > > > >=20
> > > > > This commit replaces the switch-statement that acts on the XDP
> > > > > program
> > > > > result with an if-clause.
> > > > >=20
> > > > > The if-clause was also refactored into a common function that can
> > > > > be
> > > > > used by AF_XDP zero-copy and non-zero-copy code.
> > > >=20
> > > > Isn't it fixed upstream by now already (also in gcc)?
> > > >=20
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Dce02ef06fcf7a399a6276adb83f37373d10cbbe1
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Da9d57ef15cbe327fe54416dd194ee0ea66ae53a4
> > > >=20
> > >=20
> > > Hmm, given that Daniel's work is upstream, this patch doesn't really
> > > make sense any more. OTOH it can stay in the series, and be cleaned
> > > up
> > > later.
> > >=20
> > > I'll leave it for you to decide, Jeff!
> >=20
> > I am already making revisions to the series due to another patch, so if
> > these changes are no longer needed to improve performance in RETPOLINE
> > builds, then lets drop it.
> >=20
> > Bj=C3=B6rn, can you confirm that with or without these changes, XDP
> > performance
> > stays the same for RETPOLINE builds?
> >=20
>=20
> Confirmed (on i40e using xdp1 and xdpsock samples); Same performance
> with/without this patch.
>=20
> IOW, please drop this from your next spin.

Ok, dropped.

--=-Qk5v+lMLUVRq2VE/2Gvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlzLWb4ACgkQ5W/vlVpL
7c779g//XPTRAUX5DFan2MKjHgHwwLtip6pBr9z6rftm1/F3CePjAcuAmu11+Ebk
D3kvh3ZMkwBnd8MJm9WAAeYe2w3TCgKMVn+qOgp9qRAEKO3LN5+D0I6ed+aVEMmU
79lF6lZ4cOhLY/+rOfTpqI8LeoiKj8djYAHmpV77sPDyL1Gwkkk8Z29seqphw/Lm
fbA0PcQfomVi2zQjdfDOrNC7y3XhlMMXVTAC1huResYoL2AY/tc4R3+xZnYa/D8v
J3l9fz9Zf0KEhdyU2vhXTvgyc5dL3MBfRzAcLEWNgsTIEW3FdjzY9zhISJn6Njuo
Dv/EV3GdWZKYaa9b6d8GKAGA3Rut14d1I20ZIQDHqfw9yT/WbQaqa3xshv34zQ1G
yMh7owEvY3NLLjIHjozhG9xS0ITjqi1Pz1PQsNlNzwoHTkOfpQ5BD0vm7yXJJDbP
s8bjbUHIMK8nrkx4osXjoXidKNR5cyIft00LmHKsVh66bzyzJCr40sgoQuMb3Q6q
/5pzORqAiINr/aCZnvIOn0QujkYAmGfOeE6jqHoN7CFrDQmSkNuP+fLwQDOgQiVt
kUNuOLR1bBeh04fdIdlJu3G5mrXiSCWHlK9aLMAquZF3DCKhOi7BEIRsuZbVeuH5
SxmePm5okYzj2l2DEEqnANOZ7iC6REdHDxNEpsrnnOE7yOpsvxU=
=JxSY
-----END PGP SIGNATURE-----

--=-Qk5v+lMLUVRq2VE/2Gvc--

