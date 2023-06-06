Return-Path: <netdev+bounces-8356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAEC723CB6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A39F1C20F00
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32EF29100;
	Tue,  6 Jun 2023 09:13:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90AB125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:13:07 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1F410CA;
	Tue,  6 Jun 2023 02:13:01 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f624daccd1so3089254e87.0;
        Tue, 06 Jun 2023 02:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686042779; x=1688634779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NJ4Rlr1BwW/VlJIKDrxqTk8ExusP1b+351Bo/DAekLI=;
        b=rJCxYoqFxhnln+7uwfKhrIfVeudKadx6t+qWSNl/mO36w181J5vx75LfWV5i11vLFs
         bFP+a/t+PuKp8nlle+2pdSjfXhhXmTzfwi9fMz69Hp/s+kud9IjGZbBWjacaQPRa37sI
         jhOndXcXfrKpC7FphTyHg0sSzIKfsxC6yuK9J3DTGk96Ec177oUC5xocA138xe1ztiO0
         zlnuQk8oblN0AN22Kw41Y1ubN4pMbkXzIopu9zIVxoz+fRNQftLLQqEvb45Q5+ytxwFP
         Uey5DHh5UR7+F1rWtp0oabiNpu9RCA2sUe+Jf7rhD8GvtIHn+smy3Qo8xN03Uoqt4nSr
         y9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042779; x=1688634779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJ4Rlr1BwW/VlJIKDrxqTk8ExusP1b+351Bo/DAekLI=;
        b=ke7tnHSNNyKCLihYOEXm+g/aDh9ewcmdVY4tHd9zodIftOXlthGcO2oSPTsV82V9Zv
         zpCIlVoscd+HFGqTcQw82Gi0wTD3tb6/E59nvvRDnJG4Zpbz3vgosTrlXBaeaMOL73Ca
         wdbXYVvcIgmt8eeGZMWx8NHmhvBWwh74pQF/eGLQM6e7hFi+tlsnOkLZ2zretzHY5dZQ
         bkTAsLTWMe/5+L8edUoLp+5tzs0Enjt8u4v5mWrrhHIZ6zj71e4o0RICdJUDWT9KJ0LC
         RplXk0mKWKKZqW2TJ62fp/pH+9UyAIq1utPqrded+w4oDv6Q489dhCqxDvavazqo0A48
         va9A==
X-Gm-Message-State: AC+VfDzzxvfWUDw3Ad3O4dUUx7phaFJPMcBYyL6am5ZroPOtECDrJLn+
	jTGOoZcWVw1sJ8VAFmhaHNvlPtC5DHbemg==
X-Google-Smtp-Source: ACHHUZ7NOlr9n+v7CD7+fCfytrUJRp+qlf8uQdrt9vuAMOBv8yz+ldjbrWuK96cVSTlsMrHia9ccFg==
X-Received: by 2002:ac2:5455:0:b0:4eb:18d:91de with SMTP id d21-20020ac25455000000b004eb018d91demr853152lfn.43.1686042779293;
        Tue, 06 Jun 2023 02:12:59 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id a24-20020ac25218000000b004f6337508afsm203558lfl.222.2023.06.06.02.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 02:12:59 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
	by home.paul.comp (8.15.2/8.15.2/Debian-22) with ESMTP id 3569CslI011312;
	Tue, 6 Jun 2023 12:12:55 +0300
Received: (from paul@localhost)
	by home.paul.comp (8.15.2/8.15.2/Submit) id 3569CqTk011311;
	Tue, 6 Jun 2023 12:12:52 +0300
Date: Tue, 6 Jun 2023 12:12:51 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Rani Hod <rani.hod@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mt76: mt7615: do not advertise 5 GHz on first phy of
 MT7615D (DBDC)
Message-ID: <ZH74kw4M15qjDbTz@home.paul.comp>
References: <20230605073408.8699-1-fercerpav@gmail.com>
 <ZH72YwgpywPNxbd2@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH72YwgpywPNxbd2@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

On Tue, Jun 06, 2023 at 11:03:31AM +0200, Simon Horman wrote:
> On Mon, Jun 05, 2023 at 10:34:07AM +0300, Paul Fertser wrote:
> > On DBDC devices the first (internal) phy is only capable of using
> > 2.4 GHz band, and the 5 GHz band is exposed via a separate phy object,
> > so avoid the false advertising.
> 
> Can I clarify that the second object won't hit the logic change
> below and thus be limited to 2GHz?

The second object (external 5 GHz phy) doesn't have an EEPROM of its
own, and is created explicitly with just this band enabled:

https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c#L104
https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/mediatek/mt76/mt7615/init.c#L573

So it won't hit the logic change and it will be limited to 5 GHz.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com

