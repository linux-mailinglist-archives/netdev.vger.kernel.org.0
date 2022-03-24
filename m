Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C114E6AA0
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 23:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355337AbiCXW2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 18:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiCXW2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 18:28:05 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A35ABA316;
        Thu, 24 Mar 2022 15:26:30 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t14so4953400pgr.3;
        Thu, 24 Mar 2022 15:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z0kz4cUS7VSjGdMcGeX4YE5SdchuevIjl21XixcoPrA=;
        b=ArGxX5qaFIK9xgQixjVBt4ZqvGKBlkq0vd6xiO9GjFDFiCMZJuSxTYdycHMJzV83f6
         SkUJDeXtu9Il2JaE30tqVFV3EA1xN1jG6HEYytLsFPWTSAG/4YGjyZ3c8gcuo/RXPU0m
         Sv8zgj/ns3Gs1IATig7unygowAGhQnvwtFko4I/sxagcOe+kZWhCArPyqSMxHAUZlQUu
         4SK75VgaR+Tq7dERobcXbicT6A58q7+jGsv54LODDZXv81T0PPz5WcNG7QrwBDK1iBNW
         Grw7b7BCGcpeoFN5reA42Rlhet1gOf4TagwGZhqK6VLIQDHmSdn6GeCnLurmq+g5p60c
         lZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z0kz4cUS7VSjGdMcGeX4YE5SdchuevIjl21XixcoPrA=;
        b=FF0tlYbZJxWqmcT2qodAPZo6K37YZTz3JRzbG0uu+EtOp7xhqVSgU5dVXBX6UJ1f77
         fLSypZRsMo/WRoR91WcK5tNJ7ygheir8USwHnbb2dCuxGhaQppmRBsmSfb/ZmZW/ge7/
         1LWD2U8kjPtzH3Y/rglpZ6ltf/qIQ0khdzQOuudq74D936DrR6YOKoj2gq8ZWrnk3m3F
         EDJYcsJtmYI4Z8JvPd1PnrGzHijmYxXttRNYLRDyWZ1oQwwd9xWhVgM/EbY0qIpf3KVu
         G1ufFbA347hGsCN1XnrAnPiFPjjlgxkOhWduZ5CetXPoUAEtloyeRti6GzXD+cX4MMrU
         ssfQ==
X-Gm-Message-State: AOAM533urOG996LxOWTKmmPSM7esaIBV1larSj3kBr5/ubfBlj6uL290
        Cp+PJrHx1oLGBmAVc0G2aam957ou8CdslDzjBnA=
X-Google-Smtp-Source: ABdhPJyzWMmr6ULY9oh8mhcm18dEt9qX8Izi79seRS2qM/nJJMXGko5Yu04oDq6v0XeZ1f6lczHH/bcUJB3GNUQRMwc=
X-Received: by 2002:a63:4e14:0:b0:374:4a37:4966 with SMTP id
 c20-20020a634e14000000b003744a374966mr5568860pgb.118.1648160789824; Thu, 24
 Mar 2022 15:26:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220323124225.91763-1-alvin@pqrs.dk> <YjsZVblL11w8IuRH@lunn.ch>
 <20220323134944.4cn25vs6vaqcdeso@bang-olufsen.dk> <20220323083953.46cdccc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220324080402.wu2zsewgqn2wecel@bang-olufsen.dk>
In-Reply-To: <20220324080402.wu2zsewgqn2wecel@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 24 Mar 2022 19:26:18 -0300
Message-ID: <CAJq09z62hjhfW_TYWt1tfmzVTnxzr=pyXq7a2mf55sv0EOhn4Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: make interface drivers depend
 on OF
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")

Thanks Alvin for the fix. Maybe you should add both commits.

Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Regards,

Luiz
