Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45D858C783
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 13:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbiHHL1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 07:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiHHL1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 07:27:36 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E59E0A5;
        Mon,  8 Aug 2022 04:27:35 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id j2so8493720vsp.1;
        Mon, 08 Aug 2022 04:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=zOE13jejddbMr8+f6w+Cro6mQuAWoxf8z1LO1AvcyXs=;
        b=BX1B6/3rqGs5TvArThUJfy++7RVEUXmFjuTSE8Q3VoRpPc0E42kyN4ktjTJwSpKJ5F
         MeETdu2kIexJnE/f33iENV4IVvSjUootsPUITvQsLOxWUcGsLjW4KwQ2J6aRdS6IreNn
         Dg3slFLjOaewPUDUFIpokh5RN8ZVxRgHy/gUq3/Ijqs+Bg5uLKzCfCh/M3mr2M5vD91i
         QF6liZ+vKgJJGDDbfLpaTfIlLcubsYaC97USXB1CrLthhsckW0Xhsvhm0bqMAT8s6Fr2
         JKIwzTBQ63nNLu8UFb2UCkcu4LwpTCSCZBb41Kf3+1LgwjrK1XjBxgiSxvhYX9y4cGal
         zZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=zOE13jejddbMr8+f6w+Cro6mQuAWoxf8z1LO1AvcyXs=;
        b=ld+LEPkn0IJBJ5VuF+ssRGktx5cVgrN/Y8BZiXBmrIF5BM6jVzChWEHfaGZw9HmXl4
         t0ihP2tyJ61RyOS0wmqI+Sa5n3+GcKI444X8gyOjNWUSyjVeCUKtJlXwEuA4wphsqGlJ
         YigAHYCb+WPmKX6dryCZgSXsHKTNWX99laQ+hke8HVNjbim+U2EaNcAo6Vz7cN13wm28
         pzHDMDXaHNi03sPesPgdNJ9zl66SbmnYG5OI6FwBqjdj8NSUWipqS/uk5/dwsOvbtkD4
         vfhDxXakI9LagtJmGY+ZjkBUOlG+9Q63hE6eRu/F7qDwNUSgDK3bIqK82pAmyQ3A4aV2
         blrw==
X-Gm-Message-State: ACgBeo0f5Mmf89LGBJEYDpuDRj+KBItzjiwJ7S92gWZTOjV7Hh9WVrwN
        00NMiJZ9v/G9lbMK0bTaO2Q=
X-Google-Smtp-Source: AA6agR7XSLL+PtlBqSZwSNKSgRd0JWWpOyrtsjDrvcviR6gwrH9fktwOA8WhVPm6Ciy0QLVidEVqMw==
X-Received: by 2002:a67:1a45:0:b0:356:2063:d978 with SMTP id a66-20020a671a45000000b003562063d978mr7563788vsa.41.1659958054989;
        Mon, 08 Aug 2022 04:27:34 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8fe6:4b89:54a4:c33e:b94a? ([2804:14c:71:8fe6:4b89:54a4:c33e:b94a])
        by smtp.gmail.com with ESMTPSA id j17-20020ab01d11000000b00384641c2bd1sm8679195uak.26.2022.08.08.04.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 04:27:34 -0700 (PDT)
Message-ID: <4c4554a09e4371c3bc575a3c80f7c87390a9b379.camel@gmail.com>
Subject: Re: [PATCH v2 net] net: usb: ax88179_178a have issues with
 FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Date:   Mon, 08 Aug 2022 08:27:31 -0300
In-Reply-To: <20220805175155.6f021ff4@kernel.org>
References: <9a6829ee42e4e88639d35428c378f9da7802245b.camel@gmail.com>
         <20220805175155.6f021ff4@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-08-05 at 17:51 -0700, Jakub Kicinski wrote:
> On Fri, 05 Aug 2022 17:27:33 -0300 Jose Alonso wrote:
> > To: David S. Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@l=
inuxfoundation.org>
> > Cc: netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>, R=
onald Wahl <ronald.wahl@raritan.com>
> >=20
> > =C2=A0=C2=A0=C2=A0 [PATCH net] net: usb: ax88179_178a have issues with =
FLAG_SEND_ZLP
> > =C2=A0=C2=A0=C2=A0 The usage of FLAG_SEND_ZLP causes problems to other =
firmware/hardware
> > =C2=A0=C2=A0=C2=A0 versions that have no issues.
>=20
> But you tested with 1790 previously so isn't the misbehaviour on that
> device going to come back if we remove the flag again?
>=20
>=20
There are also 0b95:1790 devices with probably different firmware/hardware
version that have issues with the patch.
The original problem needs another way to solve.
