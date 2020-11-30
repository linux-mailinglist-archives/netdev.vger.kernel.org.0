Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062062C9114
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgK3W3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730795AbgK3W3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:29:33 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713A7C0613D2;
        Mon, 30 Nov 2020 14:28:53 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id s21so11328201pfu.13;
        Mon, 30 Nov 2020 14:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nAzMv+/mbuFFwiCCS8n8Lid+mXMaJezVpww5GEW5pks=;
        b=Rh32vFtSY9kOOzSQwr/MEikm0hFOOuBIJRtIQtPsSTbcOcszdF0z19YKABUFn2fAp9
         KWSKvWMZZpm2qlcEbhMEPVymnXlLNOzy4hP6gD7HrfhVmTxA2BUleON9EuePDlbGOd2R
         TDSUG7BrzUcPYt1skK5dOh++5Ye65kNGtV4wYvpQXJla7uQN9MJ6fzMo+8IpcQZm5EPs
         nCLqIkM7kNNJaNop4BWPSBieztKg6H+fQnxvrsWdD0WWVyUr5OwhoQJ8g5zuUC+WQoZZ
         0dn6jA/0/py9d7iw5ObZCNgN+AWsBPLgqMSr2IQZJxMfJYpr8evUfesz61g/Mvcu0g6O
         m1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nAzMv+/mbuFFwiCCS8n8Lid+mXMaJezVpww5GEW5pks=;
        b=GeXNvoHl8++zV6tAlsYxFRX/bJfFkeItLAi2yWLGdYcoR/c+2CD7uwtU48gQxiZajL
         DCSe8x3Mqizu4P7tF95cKEEgosFn6f8DS6tq8cpn0oFTY3xsE/qar5dK/PBOR3xFnwMc
         MjM46m0IBSm70Ta92bczwFRSQPRHB86qZpsidoxMgcpBIqQAV6Ar2HgVhFbVbc8h+u3u
         Xh5LKREQN5OsmBCjB8RsQNT3UZJxt8iwBg2xFBEMKTCfJeGdyg/jP0IRC39bR324Ucmg
         KR0TZ4Mn8a/EhJhS8+XTC8FjcS9fYxibf3cse3kve0VlrXaJ32OQoS0S1Q4hKSlaJD2O
         Fk6g==
X-Gm-Message-State: AOAM533B2y/dZogCutb5wPGhWpXwvsCw5nXeH158+zM9LMMhATVoH5T3
        B6qqHGcdWQbQSPr+fBo12XU=
X-Google-Smtp-Source: ABdhPJzzpe28kQxnUbOfIXqOIH22llwJqZR6vl/8YLOpl9d27sgWgHFaTKyh1Cj2B+RhQT1AK9LEiA==
X-Received: by 2002:aa7:9597:0:b029:198:50a8:a6cf with SMTP id z23-20020aa795970000b029019850a8a6cfmr20899478pfj.40.1606775333056;
        Mon, 30 Nov 2020 14:28:53 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id h16sm474871pjt.43.2020.11.30.14.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 14:28:52 -0800 (PST)
Date:   Mon, 30 Nov 2020 14:28:48 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tristram.Ha@microchip.com
Cc:     ceggers@arri.de, olteanv@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, robh+dt@kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, kurt.kanzenbach@linutronix.de,
        george.mccollister@gmail.com, marex@denx.de,
        helmut.grohne@intenta.de, pbarker@konsulko.com,
        Codrin.Ciubotariu@microchip.com, Woojung.Huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Message-ID: <20201130222848.GA5215@hoboy.vegasvil.org>
References: <20201118203013.5077-1-ceggers@arri.de>
 <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
 <3569829.EPWo3g8d0Q@n95hx1g2>
 <12878838.xADNQ6XqJ4@n95hx1g2>
 <BYAPR11MB355857CFE8E9DA29BDAA900AECF50@BYAPR11MB3558.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB355857CFE8E9DA29BDAA900AECF50@BYAPR11MB3558.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:01:25PM +0000, Tristram.Ha@microchip.com wrote:
> The 1588 PTP engine in the KSZ switches was designed to be controlled closely by
> a PTP stack, so it is a little difficult to use when there is a layer of kernel support
> between the application and the driver.

Are you saying that linuxptp is not a PTP stack?

Maybe it would be wiser to design your HW so that it can work under Linux?

Nah, nobody cares about Linux support these days.
