Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3F6C921D
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 04:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjCZCaw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 25 Mar 2023 22:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZCav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 22:30:51 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4EFA5E3;
        Sat, 25 Mar 2023 19:30:50 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id fb38so3551608pfb.7;
        Sat, 25 Mar 2023 19:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679797850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16zeEm3Yx86eXVp/qbGCAi0MIpRJKwJZlSDFwjFpw+o=;
        b=yfuf8wV8TFo/3D3PUb93rl/hozXz/NwnH/ZzK4Z1uKuRcXRAvdShVvlSKOpPs/CQ6V
         jTM3+VNnG0Ose5GVRpceMr8mYOSYSBy41tvf659knJCb/EE8WuCZXCLMZgytGs0LA2Lb
         Fz/TDCa/7vHg+7H7Zzt4JvKB3qchjSbfyJJmkEEW1F0XIke+E7tryUhJ1vsDz6T9Hfh7
         JDKK6smfHOPBQ/9pq+1ryDLDAQ3FAFL+Mip8SMleIJ91PJ2+2xogOyHtjV6YkG5LiDm/
         WE0MZ4xzGc8l+WMFgOqNO/FP+ok2BgoKw3MpWICGeAphtXpD5WqASSzL0DLdJUrOfK/M
         tvNw==
X-Gm-Message-State: AAQBX9fReYgebGiU4IgpswTMXPNUGBEYIiqDqSs7ZdUItRtkyu9PBu16
        lqkD5Q7VjS3XYO6E7sAWdQWAGIfZ9n2XhC65axA=
X-Google-Smtp-Source: AKy350ZyiXVXqUs1LdjJV3le8Hl08j5qOc6C8xX3M4B2dQPsX/8enbe0vFReza0cI1e1ZcxpUPerYFKADVSMFKZFQoc=
X-Received: by 2002:a63:5f02:0:b0:507:3e33:43e3 with SMTP id
 t2-20020a635f02000000b005073e3343e3mr1874010pgb.7.1679797849615; Sat, 25 Mar
 2023 19:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230321081152.26510-1-peter_hong@fintek.com.tw>
 <CAMZ6RqJWg1H6Yo3nhsa-Kk-WdU=ZH39ecWaE6wiuKRJe1gLMkQ@mail.gmail.com>
 <f71f1f59-f729-2c8c-f6da-8474be2074b1@fintek.com.tw> <CAMZ6Rq+xSCLe8CYm6K0CyPABo-Gzrt-JUO7_XGgXum+G8k5FCQ@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+xSCLe8CYm6K0CyPABo-Gzrt-JUO7_XGgXum+G8k5FCQ@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 26 Mar 2023 11:30:37 +0900
Message-ID: <CAMZ6RqLNQG30GJH6OJR6bb4yqACn+HiTMEbhbh19Zok=5njJsQ@mail.gmail.com>
Subject: Re: [PATCH V2] can: usb: f81604: add Fintek F81604 support
To:     Peter Hong <peter_hong@fintek.com.tw>
Cc:     wg@grandegger.com, mkl@pengutronix.de,
        michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 23 Mar 2023 at 14:54, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> Le jeu. 23 mars 2023 à 14:14, Peter Hong <peter_hong@fintek.com.tw> a écrit :

(...)

> > struct f81604_bulk_data {
> >      u8 cmd;
> >      u8 dlc;
> >
> >      union {
> >          struct {
> >              u8 id1, id2;
> >              u8 data[CAN_MAX_DLEN];
> >          } sff;
> >
> >          struct {
> >              u8 id1, id2, id3, id4;
> >              u8 data[CAN_MAX_DLEN];
> >          } eff;
> >      };
> > } __attribute__((packed));

Actually, there is an alias for this attribute. Just use __packed
instead of __attribute__((packed)).

(...)
