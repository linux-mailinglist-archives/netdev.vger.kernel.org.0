Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB7419B8D4
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 01:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbgDAXKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 19:10:01 -0400
Received: from ozlabs.org ([203.11.71.1]:43981 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgDAXKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 19:10:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48t2393cr4z9sQt;
        Thu,  2 Apr 2020 10:09:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585782598;
        bh=W1LQ7dY4DJISsNESo4WCstgp6ma4QDotPYzZdMmUI9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dgF7xOOlWCvXoYCVLH4M++LeRlY3O7q789aJ8vrEkZXnKzQAlXc1rXf9nQTn9hM/t
         6urrHgWDg7MsJ2aU3ANrSWYCWxYnN8u8wOgzYGeu/o5835JM3f5GaOpupQBK09jNEF
         vuYM2slofvoU8rSl6JE+GAFt0373RiyAkL3MihHdrqzmho9Yg1oN3Oyhye/Ps1DsTN
         iG3pHCvt+6qCqizR00qe7XD//aTKBYTWLc+17UDyAsNS2yq0v5Iga6Q3RUBlHi2lLN
         kWoNXft9MmwQg4vsHWg3Htf5vfNnw053T66h2/TeMqpdbwO9fC/BtcyQZK4sEebclG
         3NwEDwq2/gtaw==
Date:   Thu, 2 Apr 2020 10:09:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: linux-next: manual merge of the net-next tree with the powerpc
 tree
Message-ID: <20200402100952.0518243f@canb.auug.org.au>
In-Reply-To: <20200306102158.0b88e0a0@canb.auug.org.au>
References: <20200306102158.0b88e0a0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/O_AaL.9YUm=PNY8z3w5CdzZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/O_AaL.9YUm=PNY8z3w5CdzZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 6 Mar 2020 10:21:58 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   fs/sysfs/group.c
>=20
> between commit:
>=20
>   9255782f7061 ("sysfs: Wrap __compat_only_sysfs_link_entry_to_kobj funct=
ion to change the symlink name")
>=20
> from the powerpc tree and commit:
>=20
>   303a42769c4c ("sysfs: add sysfs_group{s}_change_owner()")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc fs/sysfs/group.c
> index 1e2a096057bc,5afe0e7ff7cd..000000000000
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@@ -478,4 -457,118 +479,118 @@@ int compat_only_sysfs_link_entry_to_kob
>   	kernfs_put(target);
>   	return PTR_ERR_OR_ZERO(link);
>   }
>  -EXPORT_SYMBOL_GPL(__compat_only_sysfs_link_entry_to_kobj);
>  +EXPORT_SYMBOL_GPL(compat_only_sysfs_link_entry_to_kobj);
> +=20
> + static int sysfs_group_attrs_change_owner(struct kernfs_node *grp_kn,
> + 					  const struct attribute_group *grp,
> + 					  struct iattr *newattrs)
> + {
> + 	struct kernfs_node *kn;
> + 	int error;
> +=20
> + 	if (grp->attrs) {
> + 		struct attribute *const *attr;
> +=20
> + 		for (attr =3D grp->attrs; *attr; attr++) {
> + 			kn =3D kernfs_find_and_get(grp_kn, (*attr)->name);
> + 			if (!kn)
> + 				return -ENOENT;
> +=20
> + 			error =3D kernfs_setattr(kn, newattrs);
> + 			kernfs_put(kn);
> + 			if (error)
> + 				return error;
> + 		}
> + 	}
> +=20
> + 	if (grp->bin_attrs) {
> + 		struct bin_attribute *const *bin_attr;
> +=20
> + 		for (bin_attr =3D grp->bin_attrs; *bin_attr; bin_attr++) {
> + 			kn =3D kernfs_find_and_get(grp_kn, (*bin_attr)->attr.name);
> + 			if (!kn)
> + 				return -ENOENT;
> +=20
> + 			error =3D kernfs_setattr(kn, newattrs);
> + 			kernfs_put(kn);
> + 			if (error)
> + 				return error;
> + 		}
> + 	}
> +=20
> + 	return 0;
> + }
> +=20
> + /**
> +  * sysfs_group_change_owner - change owner of an attribute group.
> +  * @kobj:	The kobject containing the group.
> +  * @grp:	The attribute group.
> +  * @kuid:	new owner's kuid
> +  * @kgid:	new owner's kgid
> +  *
> +  * Returns 0 on success or error code on failure.
> +  */
> + int sysfs_group_change_owner(struct kobject *kobj,
> + 			     const struct attribute_group *grp, kuid_t kuid,
> + 			     kgid_t kgid)
> + {
> + 	struct kernfs_node *grp_kn;
> + 	int error;
> + 	struct iattr newattrs =3D {
> + 		.ia_valid =3D ATTR_UID | ATTR_GID,
> + 		.ia_uid =3D kuid,
> + 		.ia_gid =3D kgid,
> + 	};
> +=20
> + 	if (!kobj->state_in_sysfs)
> + 		return -EINVAL;
> +=20
> + 	if (grp->name) {
> + 		grp_kn =3D kernfs_find_and_get(kobj->sd, grp->name);
> + 	} else {
> + 		kernfs_get(kobj->sd);
> + 		grp_kn =3D kobj->sd;
> + 	}
> + 	if (!grp_kn)
> + 		return -ENOENT;
> +=20
> + 	error =3D kernfs_setattr(grp_kn, &newattrs);
> + 	if (!error)
> + 		error =3D sysfs_group_attrs_change_owner(grp_kn, grp, &newattrs);
> +=20
> + 	kernfs_put(grp_kn);
> +=20
> + 	return error;
> + }
> + EXPORT_SYMBOL_GPL(sysfs_group_change_owner);
> +=20
> + /**
> +  * sysfs_groups_change_owner - change owner of a set of attribute group=
s.
> +  * @kobj:	The kobject containing the groups.
> +  * @groups:	The attribute groups.
> +  * @kuid:	new owner's kuid
> +  * @kgid:	new owner's kgid
> +  *
> +  * Returns 0 on success or error code on failure.
> +  */
> + int sysfs_groups_change_owner(struct kobject *kobj,
> + 			      const struct attribute_group **groups,
> + 			      kuid_t kuid, kgid_t kgid)
> + {
> + 	int error =3D 0, i;
> +=20
> + 	if (!kobj->state_in_sysfs)
> + 		return -EINVAL;
> +=20
> + 	if (!groups)
> + 		return 0;
> +=20
> + 	for (i =3D 0; groups[i]; i++) {
> + 		error =3D sysfs_group_change_owner(kobj, groups[i], kuid, kgid);
> + 		if (error)
> + 			break;
> + 	}
> +=20
> + 	return error;
> + }
> + EXPORT_SYMBOL_GPL(sysfs_groups_change_owner);

This is now a conflict between the powerpc tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/O_AaL.9YUm=PNY8z3w5CdzZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6FH0AACgkQAVBC80lX
0GxUPwf+JDKJPVeou9Fa4UrOIU+wH1H9Xu0Dmrp01ZNjOX9/sl8V0tlarr+Xteyo
On5+2P/dAMM+tSg7KnLU/5/Z/0OzIabZz7mwVQyED4MWFGION3ng3uYIICop2xfo
L5v0uG21pTEeOkg00LL5i7hlQVfl/u9r18ZMzNQ7+7gQqWwMGJYyBs6yNxaiEEim
6Rk1QkCYhM2LDLZ2GQQng/5kv2jqW8vds0iIxcnYA5fm1Ax90yBMLwoIpdjdQ1yO
FR/TQ9JVyysSZ4vMFzyGz0rI5AIpZ4zHwQzLTJAniDhUkQ2+qHX+EzK8YTkvnRmW
DPqam2ngdpWD4TeZiBHMCRwHRdEasw==
=HUtF
-----END PGP SIGNATURE-----

--Sig_/O_AaL.9YUm=PNY8z3w5CdzZ--
