Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9415125A740
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 10:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBIAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 04:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBIAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 04:00:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E02C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 01:00:13 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so4156421wrl.12
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 01:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=thu2P1heOkAbE27i18ALaV11LBqwhtsgbPuTuDW01YE=;
        b=10BPoJUf0Vfj77II+oIuREgH0IsZsQQdssXut3/PAw2qMKuAmyriwznfDR7JwTt8dN
         QxbScRKFi5Rfy20WDJQpNNBVtB1M4bJzjU+JgnvDrDr2dTWJ1UbkfOmtwIQO79lR36JS
         xMx6dYZEkTBuIWCUxyhblD7HL8iHCePTVOdENQz8A/FELm40R0SFQTEEVU2F1yxCdkKD
         Wih4p5ZR33nas4QyXeFr61lzI+lVFAnZwX+9JKcE5dhrwUF/O+oJ0R0chemogqA0jOzg
         RsDYQrOE/4/OUPBXsbaviZsYKmbfddcSSpageKHNcDH+5HDwLtm6SEVxBYVaie1Gh2Dh
         Spbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=thu2P1heOkAbE27i18ALaV11LBqwhtsgbPuTuDW01YE=;
        b=twV234B4hHcmZAF38kuOhsXPcCfgOBVHKC77YShju1kvLIJlNUlzIbT8n1YrCqHcXF
         ALMmEyIw5RV3PYMjkOy6MaFREdF6Ab27ZK3IdoC2OQBZC6/1cAaWrr5QkANbMqjNMb41
         mqmTnYq9PcD1aMkHzrJWMPpfXnrM79pxtgIRLj2HaXzklHTUC0Vb5vswgsEmbAkru0QL
         3JT92LEs4MupEURG4P8mqFTAoVsi7mGXoKWjWpqqcSTHjwbDS2sliEo4PNix7/6Fcccx
         8IEN3OX3ZofFP7RJvDkrJWYpZ4vXRmIXo9gmUCMSErmP+LdeFRU84QVwxriwIljmyM6F
         9vuw==
X-Gm-Message-State: AOAM53065KdI1w9HL4rVMRy8kd9Bf4eJetasUE/3atiVTFsKvN18nNAL
        nvQjcOUzgj4FZyS7N0j0ns4TrA==
X-Google-Smtp-Source: ABdhPJy13/jG0zqJNhdez8dyyuITNJygrV3yG3YME3s7xA1n3KGAMyNOylGRBFmS3M8V5O7V86v+Cg==
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr5812760wrt.196.1599033612527;
        Wed, 02 Sep 2020 01:00:12 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 70sm5602760wme.15.2020.09.02.01.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 01:00:12 -0700 (PDT)
Date:   Wed, 2 Sep 2020 10:00:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200902080011.GI3794@nanopsycho.orion>
References: <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901081906.GE3794@nanopsycho.orion>
 <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901091742.GF3794@nanopsycho.orion>
 <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 02, 2020 at 06:26:12AM CEST, parav@nvidia.com wrote:
>
>
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Wednesday, September 2, 2020 2:59 AM
>> 
>> On Tue, 1 Sep 2020 11:17:42 +0200 Jiri Pirko wrote:
>> > >> The external PFs need to have an extra attribute with "external
>> > >> enumeration" what would be used for the representor netdev name as well.
>> > >>
>> > >> pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
>> > >> pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf
>> > >> pfnum 0
>> > >> pci/0000:00:08.0/2: type eth netdev enp0s8f0_e0pf0 flavour pcipf
>> > >> extnum 0 pfnum 0
>> > >
>> > >How about a prefix of "ec" instead of "e", like?
>> > >pci/0000:00:08.0/2: type eth netdev enp0s8f0_ec0pf0 flavour pcipf
>> > >ecnum 0 pfnum 0
>> >
>> > Yeah, looks fine to me. Jakub?
>> 
>> I don't like that local port doesn't have the controller ID.
>> 
>Adding controller ID to local port will change name for all non smartnic deployments that affects current vast user base :-(
>
>> Whether PCI port is external or not is best described by a the peer relation.
>
>How about adding an attribute something like below in addition to controller id.
>
>$ devlink port show
>pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 ecnum 0 external true splitable false
>                                                                                                                                                    ^^^^^^^^^^^
>
>> Failing that, at the very least "external" should be a separate attribute/flag from
>> the controller ID.
>>
>Ok. Looks fine to me.
>
>Jiri?

Yeah, why not.

>
>> I didn't quite get the fact that you want to not show controller ID on the local
>> port, initially.
>Mainly to not_break current users.

You don't have to take it to the name, unless "external" flag is set.

But I don't really see the point of showing !external, cause such
controller number would be always 0. Jakub, why do you think it is
needed?
