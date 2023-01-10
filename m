Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D591E6646FC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbjAJRGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbjAJRFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:05:55 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B0A251
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:05:52 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p24so13826213plw.11
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eBuf8+7gTLyxqcVb4HpV/jmEuYz0Dpuvu2HM87uNSu8=;
        b=GaJ9yNjd6onwg40tp7iFKbvHlgoGFoBKvjuNZ4aG+GDpwQSjoct6cUkA7YOxxvV5C6
         8o86U73Lbl8k0Vsk5BGG85bAHg7zaoFXVc7S7ugJk7AU2c2CXZfT+5lxRTZA7Y6//c0X
         mu3TcVg1Fr64052IEqjjfjCVQVkOaEjVJZGloA5xNPjr/TGI51wbaR5ZP6yazmTVPKom
         bi51RIAy0XwJdM5u0mbJb6y+NHW3imxktIJxUfTR7512ZxNMMxhfHfrlI7I4ZlKtXrVC
         oB/YZ1HfaOE/8HHLJRKEsXWJ2+asKDvCVoxWH6LeXDtYIuNeEc4hRicI6flhVgbgFjlZ
         t6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eBuf8+7gTLyxqcVb4HpV/jmEuYz0Dpuvu2HM87uNSu8=;
        b=puzyOiJ2/WUig9maB66+X9JvmgVtvuD2ea64184pNGhmYhZ/b/bSyOL/lSAmXcabXO
         JOIUnjaP+P2+eU51vsepaoavYbrKV1V8drA/+ieE8eAkOb4+WmU539QzqpraGu9oLwIT
         2DZNqALX4CL7P/qaK8t4jQzIVjSGOQRAOt/2bK87+4MOQhEh1Ivv6QpJbWzncnTnwHwx
         7iGZqWLK67/YSyoxg01x+QzIom1DXqQN675jwF+pRGHIAEEQXqSOckbgWKJP/b4zIydb
         rDWZjtBHBjUgYGfUuve+c1mtzCZEMQfBi8zUY1tPF2vQ9Bwt+sJa+M+G7ymGKPkiW3nl
         tNrw==
X-Gm-Message-State: AFqh2kr6of7UGwNwB5vAWSxseDQDMPjOF45qQPZSF5rjiujAKOtzgIwt
        ze01BQS+WPo/Z3Lu7ZvPwvc=
X-Google-Smtp-Source: AMrXdXuhOtU6zEoc1Pl7Lmt4g1OoAibcCyGcYBkfCmL5vW9vmJAS0gxlHj6BUa4+y4O3i7E2Djo/3w==
X-Received: by 2002:a17:90b:270e:b0:223:b552:4f24 with SMTP id px14-20020a17090b270e00b00223b5524f24mr70033135pjb.13.1673370351741;
        Tue, 10 Jan 2023 09:05:51 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id oa11-20020a17090b1bcb00b00212cf2fe8c3sm2485683pjb.1.2023.01.10.09.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 09:05:51 -0800 (PST)
Message-ID: <619a15434759cdf6b73f87ae30945d3d1d40d700.camel@gmail.com>
Subject: Re: [PATCH net-next v4 06/10] tsnep: Substract
 TSNEP_RX_INLINE_METADATA_SIZE once
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 09:05:49 -0800
In-Reply-To: <20230109191523.12070-7-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-7-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> Subtrace size of metadata in front of received data only once. This
> simplifies the RX code.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

s/Subtrace/Subtract/

Otherwise the patch looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

