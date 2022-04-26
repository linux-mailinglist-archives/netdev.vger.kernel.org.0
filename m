Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F37A510003
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiDZOJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351447AbiDZOIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:08:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723B31FA77
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:05:46 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l18so9677780ejc.7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v4PZftkkaFaD0w9q1I3NyqewH7haFVEmQYaSb8AaZE8=;
        b=B6FRL/Fffce0Zf4mujR4zPGdmDIFQUnHZtD1qmYuGtSTllSwAjYqXarkfw6EgTA2R7
         HAF/uAUzR9tujtFw/fclINawx12Vgeu7pPu8oRFl/5GGdQiY8z3BgfjGYIH/20CuAcVQ
         Ded96JgxsHEfTKLU3bAebyDjOZogJljzubQPPUUuxxEi6MdHXFe7e5z+J2EJyDjmn/DW
         qt3k+KVm6ROpCpmii8JPX4IPjw3wGUtZQf5ySJT+Rd0VbKEv3SbPZouo7Ii23qKZ9o6G
         k5ToEJUvq9XU9o/SSjo6GfIO2GstRk7FRWzOJkRN9/BJ8GY2HMP/ImqugMGwdX9GbXVc
         ZYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v4PZftkkaFaD0w9q1I3NyqewH7haFVEmQYaSb8AaZE8=;
        b=Y6quqz74m0xSu2ekUilfltpuxLcHHrzHZ1AE21vTSVxYN7uS2rQaG07JnmSkldjWBg
         Et+kXB63h2mylZy0eZ/IbtYe5GmaLedM6qe0nGEQxOAXkvYmRnxpHRmYiHCrGPFX9aLH
         vokv4qrg+Y5pZ9VLDrmg+C9+06POAi9Ifou/PkUoGlG1lDadParHDNfdD9RrQoKA73Wn
         MdNTnsZniHhHar+Sd2ZyI1+tyWXhkMv7DgRvHZJqWtWIZo9iZdzjGwVxIyxONL+TT6pa
         nKoOD1fFBLfx04TlteMLj83wlk4DmNFozai+PUXdtjM2zlFigbOI7Dwldj3yIUnWYeLN
         zEAA==
X-Gm-Message-State: AOAM533FATcqSKSID7MeolIegruwE/SzVKNdtC5qdktsjqDvTBL/hdKX
        d0+LdUW0tZruNmoDEJ63JLSqGw==
X-Google-Smtp-Source: ABdhPJzPLxd/KLmoQ3q2qzaCbOHKZYETkdyxuPbFwP1CSfxOAJcuu/QmulcB2dCTlSa9Eux2h+lIIQ==
X-Received: by 2002:a17:907:9958:b0:6e7:f67a:a1e7 with SMTP id kl24-20020a170907995800b006e7f67aa1e7mr20740543ejc.400.1650981945047;
        Tue, 26 Apr 2022 07:05:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k23-20020a1709062a5700b006ccd8fdc300sm4862561eje.180.2022.04.26.07.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:05:44 -0700 (PDT)
Date:   Tue, 26 Apr 2022 16:05:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Ymf8N19bQYcKJJ1g@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <YmeViVZ1XhCBCFLN@nanopsycho>
 <YmflStBQCrzP8E6t@lunn.ch>
 <YmfoXsw+o9LE9dF3@nanopsycho>
 <Ymf3jKNeyuYHzsBC@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymf3jKNeyuYHzsBC@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 03:45:48PM CEST, andrew@lunn.ch wrote:
>> Well, I got your point. If the HW would be designed in the way the
>> building blocks are exposed to the host, that would work. However, that
>> is not the case here, unfortunatelly.
>
>I'm with Jakub. It is the uAPI which matters here. It should look the
>same for a SoC style enterprise router and your discombobulated TOR
>router. How you talk to the different building blocks is an
>implementation detail.

It's not that simple. Take the gearbox for example. You say bunch of
MDIO registers. ASIC FW has a custom SDK internally that is used to
talk to the gearbox.

The flash, you say expose by MTD, but there is no access to it directly
from host. Can't be done. There are HW design limitations that are
blocking your concept.
