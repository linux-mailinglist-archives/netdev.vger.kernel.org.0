Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC8181549
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 10:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgCKJuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 05:50:32 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41494 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKJuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 05:50:32 -0400
Received: by mail-ed1-f68.google.com with SMTP id m25so2070703edq.8;
        Wed, 11 Mar 2020 02:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fCEtSOjGKWZDiJGPZb/06Cw2I8STvTOMgUuHbv6hqmM=;
        b=Kg0G/ShWrHMS7umeyyWvSP5yz1weaZombe3EbZTmMK0bu8Ai7YQiWEe5Cl3ie+NbcO
         290Yuy7ZfW7Xm7qwskcJ649//1IC5ndMUVIyixylmC4cT4X+a7ZWMFBsGXsh53i2G277
         nmvpMCRx1/KtHjrBYLG8e/73zChpp4tAwYBGf3ikH6iBYfwWcXpUrC7N3B8tar18q2lw
         rNygmIpLxOq+8lAFPatsp0TpYln0ZGXFBLLoGb7WPAtXOO2NiCitxihS8yrOwfMFt9oS
         bXA9AGLaiXgtu4AJwIOAxsnxNvxmjU5VwscfxE25HAyckPYfXFmYSEx4eZ7yd5iOSIu4
         g0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCEtSOjGKWZDiJGPZb/06Cw2I8STvTOMgUuHbv6hqmM=;
        b=nV1kl9Oqax6Ag6tUbLbJG99n6ivLxf+eeA9q75vvFxWihGUD/mBX4k6wa9bb/h7DHM
         PFqOGNZoEwMkRww8ROimKRAbIP5mtcyxX1tRi72bPKmYye9xTnn9kp07RYzKQ0n+nSoy
         dTVLcbYAEWhgicWn2mo3LkGciZ+xJ+SifNiDrIy2na7e994LJ0ySHxuq23fy7BTSF8lC
         nCo+TV+N6qqV3Z45g8tqb0W1u2kcWgs9JuaMRzVIlwColUBVFaJU4PN83zsiFEFk5DFC
         mjb6Gy5ur13rVgAMs/utIbaJFCy7GRdxiETy9NOHMsF21sMF4/r+5WtNWhyWuVDXcSrd
         ZtTg==
X-Gm-Message-State: ANhLgQ0vg2jddmNn9TzQHV/Cjoy0ER65kZEs2LgudNIOajolbNpTkiJ8
        h1Lu9u0g8OEkjY1Viy9qw9fNTpNKvCfGehziu6R62qkr
X-Google-Smtp-Source: ADFU+vs0+8wWoArNexkwpDDRCjbYIOgng5dA1XuotC4sNzt1ak8Gk3E2rjf2tDCrsPQv8CjyrSyusyb5q8zIc8I4Z/Y=
X-Received: by 2002:a50:9b07:: with SMTP id o7mr1971382edi.139.1583920228519;
 Wed, 11 Mar 2020 02:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200311123318.51eff802@canb.auug.org.au>
In-Reply-To: <20200311123318.51eff802@canb.auug.org.au>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Mar 2020 11:50:17 +0200
Message-ID: <CA+h21hq1pVEJCZHzM4mCPEWhOL-_ugJ5h=EA4g=Lv5sweXGnAA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Wed, 11 Mar 2020 at 03:34, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   drivers/net/ethernet/mscc/ocelot.c
>
> between commit:
>
>   a8015ded89ad ("net: mscc: ocelot: properly account for VLAN header length when setting MRU")
>
> from the net tree and commit:
>
>   69df578c5f4b ("net: mscc: ocelot: eliminate confusion between CPU and NPI port")
>
> from the net-next tree.
>
> I fixed it up (I think - see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.
>
> --
> Cheers,
> Stephen Rothwell
>
> diff --cc drivers/net/ethernet/mscc/ocelot.c
> index d3b7373c5961,06f9d013f807..000000000000
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@@ -2310,27 -2323,34 +2329,34 @@@ void ocelot_configure_cpu(struct ocelo
>                          ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
>                          ANA_PORT_PORT_CFG, cpu);
>
> -       /* If the CPU port is a physical port, set up the port in Node
> -        * Processor Interface (NPI) mode. This is the mode through which
> -        * frames can be injected from and extracted to an external CPU.
> -        * Only one port can be an NPI at the same time.
> -        */
> -       if (cpu < ocelot->num_phys_ports) {
> +       if (npi >= 0 && npi < ocelot->num_phys_ports) {
>  -              int mtu = VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
>  +              int sdu = ETH_DATA_LEN + OCELOT_TAG_LEN;
>
>                 ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
> -                            QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
> +                            QSYS_EXT_CPU_CFG_EXT_CPU_PORT(npi),
>                              QSYS_EXT_CPU_CFG);
>
>                 if (injection == OCELOT_TAG_PREFIX_SHORT)
>  -                      mtu += OCELOT_SHORT_PREFIX_LEN;
>  +                      sdu += OCELOT_SHORT_PREFIX_LEN;
>                 else if (injection == OCELOT_TAG_PREFIX_LONG)
>  -                      mtu += OCELOT_LONG_PREFIX_LEN;
>  +                      sdu += OCELOT_LONG_PREFIX_LEN;
>
> -               ocelot_port_set_maxlen(ocelot, cpu, sdu);
>  -              ocelot_port_set_mtu(ocelot, npi, mtu);
> ++              ocelot_port_set_maxlen(ocelot, npi, sdu);
> +
> +               /* Enable NPI port */
> +               ocelot_write_rix(ocelot,
> +                                QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
> +                                QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
> +                                QSYS_SWITCH_PORT_MODE_PORT_ENA,
> +                                QSYS_SWITCH_PORT_MODE, npi);
> +               /* NPI port Injection/Extraction configuration */
> +               ocelot_write_rix(ocelot,
> +                                SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
> +                                SYS_PORT_MODE_INCL_INJ_HDR(injection),
> +                                SYS_PORT_MODE, npi);
>         }
>
> -       /* CPU port Injection/Extraction configuration */
> +       /* Enable CPU port module */
>         ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
>                          QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
>                          QSYS_SWITCH_PORT_MODE_PORT_ENA,

What would be the takeaway here? I did bring the fact that it will
conflict to David's attention here, not sure what else should have
been done:
https://www.spinics.net/lists/netdev/msg636207.html
The conflict resolution looks fine btw, I've tested linux-next and it
also works.

Thanks,
-Vladimir
