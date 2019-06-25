Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1303B52645
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFYIQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:16:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44664 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfFYIQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:16:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16so16714217wrl.11
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XP+LR0Z1yUaHNGg2vz822EXoiiGKhM28w8FvAln5Lh8=;
        b=zFhYw/JNYr/XKsr9ac9Kp4yyTxpYlzuCQl+RrxkXkNKrQzQvnSgB3KwxnfNuTbhKIh
         q3hcAOtfJyMG8W0kJz/EyMq2ipdZxWzrXPzWjOUYQwDKWAyvLyM3l5MPO/0bQ0VxCccd
         E2SD3IMXSXvJ0Vc86hMiSPWWS2N8NTRZ+xAHIYsWABHhS81L6J6dRB2j/zcH6L8O3zAp
         t56SGh2u3exjC+M+NEuwFz7hLRkQ5zxRHje1TsnfxILTuU+Wp4Jojtcpk0ZEhv6Bn4WU
         TeoyzHWXy7DViyhOc4bstHT5TKwAOwV5ZsEziuS0MzytAgY6RLk7RhslxhMz0XW4BgNc
         5Hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XP+LR0Z1yUaHNGg2vz822EXoiiGKhM28w8FvAln5Lh8=;
        b=LqItH/MetH1LQTffdL2DEO2M3gbOw4cY0LNLNsJhoFfsKH1umvu6AFTtF9N0Z2xffa
         ba8dQBeWj5J4GqdHAeg3n58BFlse3ckUFiW7BO/CS1zWgkJ8xR9zTgnjX6P8u9X8uWX2
         /g0PjalBdCcsVYzbH6Y2NW1vpN8dKyglGz6Ko38Trmm0FDIumMT+Qi4fVCjDuyNP/x2J
         NvNYSU29MOFqBsy3buazM99gqXBzypSo9q9q8FfW7OYc/qvhMqVghzUEQ/0hDA8oysY5
         PM7v69/K9MIWplh56PUW/ZxOydtosk/HvvuNrAKd1LKTwaP+oBlMJXUXO2WQkUUZHsRM
         +xDA==
X-Gm-Message-State: APjAAAW7fFUAIL+RY/i0uwQ4l5tpdY05Oe0B4JXMDRvXtcX27ZVoznnu
        CE+46sN//zllrBvNUV9UAEPdHQ==
X-Google-Smtp-Source: APXvYqxETSqbBbYaMMsbOxCTG/Tu/fZTu6vX3H5zDTynqWK/N7lHRwkxMMRNm7WeXeNDRFv3LZ9n7g==
X-Received: by 2002:adf:ee03:: with SMTP id y3mr36580164wrn.128.1561450588386;
        Tue, 25 Jun 2019 01:16:28 -0700 (PDT)
Received: from localhost (static-84-42-225-170.net.upcbroadband.cz. [84.42.225.170])
        by smtp.gmail.com with ESMTPSA id x17sm11819379wrq.64.2019.06.25.01.16.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:16:28 -0700 (PDT)
Date:   Tue, 25 Jun 2019 10:16:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 11/12] net: flow_offload: don't allow block
 sharing until drivers support this
Message-ID: <20190625081627.GA2630@nanopsycho>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-12-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-12-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't understand the purpose of this patch. Could you please provide
some description about what this is about. mlxsw supports block sharing
between ports. Or what kind of "sharing" do you have in mind?
