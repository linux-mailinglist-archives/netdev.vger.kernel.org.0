Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD23044AE
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390031AbhAZRHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390411AbhAZItC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F3620793;
        Tue, 26 Jan 2021 08:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611650901;
        bh=Ii9h7tu6rlb17VtHNV7jap79gnKT5ToYbuNVC5byeDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eiq5xmJ/5nwYLMKM3nVI7oWCsU3DwM+02Q/slPFtq/D6W7MAa6T1ClmejLIrq6H9Y
         5ltkO190tl04dACulkZngZUukLjPJ2e1wVsfFEtIEU8lAgKaEj3dtqU4zS2HoK+xfA
         ByUIv2I8KS1/pG4plzWOWU4oLeOJa9zfvMHwSS5crYZhL+E0mAGPgbEchycAzQTron
         uqLm5j0jw4T+r86d077gXeV3tgMUpD9JKIbo7FLB/+qbfKd3SC80OTPBnNoXn1RA8q
         jx/Vx8VHiKgB5mH8337hhgIeMimnpvwHM/4Y5g8AbcDN7sJh45Kc5Q/eqPOHKCfaGO
         WL0r0EdEAFeTw==
Date:   Tue, 26 Jan 2021 10:48:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210126084817.GD1053290@unreal>
References: <20210124131119.558563-1-leon@kernel.org>
 <20210124131119.558563-2-leon@kernel.org>
 <20210125135229.6193f783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210126060135.GQ579511@unreal>
 <48c5a16657bb7b6c0f619253e57133137d4e825c.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c5a16657bb7b6c0f619253e57133137d4e825c.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 12:20:11AM -0800, Joe Perches wrote:
> On Tue, 2021-01-26 at 08:01 +0200, Leon Romanovsky wrote:
> > On Mon, Jan 25, 2021 at 01:52:29PM -0800, Jakub Kicinski wrote:
> > > On Sun, 24 Jan 2021 15:11:16 +0200 Leon Romanovsky wrote:
> > > > +static int pci_enable_vfs_overlay(struct pci_dev *dev) { return 0; }
> > > > +static void pci_disable_vfs_overlay(struct pci_dev *dev) {}
> > >
> > > s/static /static inline /
> >
> > Thanks a lot, I think that we should extend checkpatch.pl to catch such
> > mistakes.
>
> Who is this "we" you refer to? ;)

"We" == community :)

>
> > How hard is it to extend checkpatch.pl to do regexp and warn if in *.h file
> > someone declared function with implementation but didn't add "inline" word?
>
> Something like this seems reasonable and catches these instances in
> include/linux/*.h

Thanks

>
> $ ./scripts/checkpatch.pl -f include/linux/*.h --types=static_inline --terse --nosummary
> include/linux/dma-mapping.h:203: WARNING: static function definition might be better as static inline
> include/linux/genl_magic_func.h:55: WARNING: static function definition might be better as static inline
> include/linux/genl_magic_func.h:78: WARNING: static function definition might be better as static inline
> include/linux/kernel.h:670: WARNING: static function definition might be better as static inline
> include/linux/kprobes.h:213: WARNING: static function definition might be better as static inline
> include/linux/kprobes.h:231: WARNING: static function definition might be better as static inline
> include/linux/kprobes.h:511: WARNING: static function definition might be better as static inline
> include/linux/skb_array.h:185: WARNING: static function definition might be better as static inline
> include/linux/slab.h:606: WARNING: static function definition might be better as static inline
> include/linux/stop_machine.h:62: WARNING: static function definition might be better as static inline
> include/linux/vmw_vmci_defs.h:850: WARNING: static function definition might be better as static inline
> include/linux/zstd.h:95: WARNING: static function definition might be better as static inline
> include/linux/zstd.h:106: WARNING: static function definition might be better as static inline
>
> A false positive exists when __must_check is used between
> static and inline.  It's an unusual and IMO not a preferred use.

Maybe just filter and ignore such functions for now?
Will you send proper patch or do you want me to do it?

> ---
>  scripts/checkpatch.pl | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 4f8494527139..0ac366481962 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4451,6 +4451,18 @@ sub process {
>  			}
>  		}
>
> +# check for static function definitions without inline in .h files
> +# only works for static in column 1 and avoids multiline macro definitions
> +		if ($realfile =~ /\.h$/ &&
> +		    defined($stat) &&
> +		    $stat =~ /^\+static(?!\s+(?:$Inline|union|struct))\b.*\{.*\}\s*$/s &&
> +		    $line =~ /^\+static(?!\s+(?:$Inline|union|struct))\b/ &&
> +		    $line !~ /\\$/) {
> +			WARN("STATIC_INLINE",
> +			     "static function definition might be better as static inline\n" .
> +				$herecurr);
> +		}
> +
>  # check for non-global char *foo[] = {"bar", ...} declarations.
>  		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
>  			WARN("STATIC_CONST_CHAR_ARRAY",
>
>
