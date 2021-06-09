Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DE83A201C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhFIWdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:33:46 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:40822 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhFIWdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:33:45 -0400
Received: by mail-ej1-f41.google.com with SMTP id my49so24094329ejc.7;
        Wed, 09 Jun 2021 15:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qnrz+d0W6EP/OXsEGMakUPgEbPOwWrm7cX+jALqX9ic=;
        b=Mu/E/S4+HM9QDnhfr57f18w4iNWiaW5fr2x/HfVG1Q52OV89wfCihIHI/qYItFppp6
         /7kgFtDlKh2g4s/ZRAv7XiwhhxNcCTU4fI+0C3Tr8htDbHElQXqKb+/2bVmvua3g7VUM
         ViUnHX9heQQKQwwB5e2gCqOuNY3LtHd0iVOMJEQ1i/5KmciNDIS5vJfJUEtR8aV2OoAJ
         J0+4ziwMVvFEv+LA69pJLTgXAeSCRoXFfJ6rK15qRhinf47mh4A8hKop20JUnz/FMDkb
         qODV5kWdZhv/wP5Fb0N2lgxMl+z7t6UVeo06cOTU1dudMy6B2bDt1pMfRNFo8lmtt35I
         U+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qnrz+d0W6EP/OXsEGMakUPgEbPOwWrm7cX+jALqX9ic=;
        b=ISGM++dtxfXhvRbm6vcPwfyiWrm8DxoPHDG5XXDiYxWPeUiNS+zNsVjcnwGjPN5Zka
         3THZvtJ8Ubw8IUgGjv5trsxPGdNC2hjsSwACnSpynrOvIAvK+DrYxLxR6201i0LPHF0/
         Va6nlwYcfJHWjNr+TKSkovppVOA3nnc0vPHr2Ob7Nvgr3ZndSrOLLfTL+Qn+P8SthnWv
         eC0Z7ATfsljQrDIZ20E0YkTV0LIZnvTBaauXh65n11rDAj7PJiAcXP0c/vlo4vooj2ps
         9SKvxWN0Modg6TF/91qgVZbqqs6QkV++dT4bZaWEHupxcwIGsIpj2ncuA3DY7OmxsKSk
         jHJw==
X-Gm-Message-State: AOAM532wcc0fNVmOsua554I4hhVBQn1btzhc5REmujjdFk3cXo9gt0oO
        AGVbkQCOFAGm4v77164TWj0=
X-Google-Smtp-Source: ABdhPJzkOEEZmcK8SU60iXpYtlX5JkiuTVxdUJ9FCW1pJP7zogFEk+m1ryKNi4ysNdSnxvb93+UVcA==
X-Received: by 2002:a17:907:f9b:: with SMTP id kb27mr1809860ejc.44.1623277849503;
        Wed, 09 Jun 2021 15:30:49 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c26sm422043edu.42.2021.06.09.15.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:30:49 -0700 (PDT)
Date:   Thu, 10 Jun 2021 01:30:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, mnhagan88@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always
 tagged
Message-ID: <20210609223048.xsnyaoqzr6uhlqsm@skbuf>
References: <20210608212204.3978634-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608212204.3978634-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 02:22:04PM -0700, Florian Fainelli wrote:
> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
> VLANs") forced the CPU port to be always tagged in any VLAN membership.
> This was necessary back then because we did not support Broadcom tags
> for all configurations so the only way to differentiate tagged and
> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
> port into being always tagged.
> 
> With most configurations enabling Broadcom tags, especially after
> 8fab459e69ab ("net: dsa: b53: Enable Broadcom tags for 531x5/539x
> families") we do not need to apply this unconditional force tagging of
> the CPU port in all VLANs.
> 
> A helper function is introduced to faciliate the encapsulation of the
> specific condition requiring the CPU port to be tagged in all VLANs and
> the dsa_switch_ops::untag_bridge_pvid boolean is moved to when
> dsa_switch_ops::setup is called when we have already determined the
> tagging protocol we will be using.
> 
> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Florian, does the hardware behave in the same way if you disable
CONFIG_VLAN_8021Q?
