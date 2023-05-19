Return-Path: <netdev+bounces-3992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3828709F49
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 738BB1C21349
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8991C12B87;
	Fri, 19 May 2023 18:43:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72211C8F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 18:43:31 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93E81A8
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:43:29 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f4234f67feso8845e9.0
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684521808; x=1687113808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F7ADbMEeGTow7uzHXVJ7EWjekmJRyxwC2hamfTPH2cU=;
        b=oYh3TklvbclGO8uY7mRfMrlutFD8Zv4Tr94rAoxiRfulYxTEkpTncCbtsHewRrSv8f
         CMJGjBOFq7LMaPYEGDi4yml/WMODr9buPtIzonh4sOVcV6O1fVhwB7ByjF2jbk/dLJKl
         Bs9vF5aZmg7qvXp2yWYq3rv3LV1r5aL0hfM9+kydBDluQc9slO18PtCGnLcdXNOK5Vkt
         92xA/ST/4lI+YEQVcDFEy6RJ2RKWV3SeZpqENqXi5hV7UahFrLx2n8EIrCbLekKYVlZH
         m+uFf24vy/5TFu6XObP+bV1ppxoULUtVcA32obkezug6vm5qcfcTUUBfdP/9S5EvZj6p
         hhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684521808; x=1687113808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7ADbMEeGTow7uzHXVJ7EWjekmJRyxwC2hamfTPH2cU=;
        b=ICZ7zLUbuNMl0Q5GBamrdna58P/CqIRiyJPgvDDvDb3o1m/feWHT3g8sIxfnLsNvgF
         1bM85+vUM3ih4u/AGr7ijsvkoJKlVBPc4VcmP11T2roSbxgR8wyv/CfMlgk3RQRzEIim
         SaI3wEuOfDMoIZ75ImxsIqv0s9d0PXJ4WC/LmBtMJw5k4hG2bobyESgHyPV+kffS/oKy
         vlMSumMpz7k1g5C3S3koEh3jNgTPU74lXU2gfCpjbJ/ckKnzx9Ckqviyt9BqSCOGi3Rg
         IdOixUJ+LVp1bhMJr6QhEFc8Lc1urXWri0NsJezrOrW8AdzdQP5SkGmN2gb+gUG0tCGC
         j82A==
X-Gm-Message-State: AC+VfDytH0ee9x8s/bTbFpVVrhXXO6Rxj30m8E4aCTfaJXlyjBu237EL
	IH9rgxIT7t+dUMOeR1TcAEceMAQAzW4lGDbR+co0dg==
X-Google-Smtp-Source: ACHHUZ7QKdbpc8HDR/3l7hVDAg0UkTZvkwOPqjBlJ16OdxFgA56o4t1zmyGchaccBrevpKy+XCKwv04xozOwhLg798c=
X-Received: by 2002:a05:600c:6029:b0:3f1:6fe9:4a95 with SMTP id
 az41-20020a05600c602900b003f16fe94a95mr225881wmb.4.1684521808389; Fri, 19 May
 2023 11:43:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org> <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org> <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
 <20230519013710-mutt-send-email-mst@kernel.org> <bb44cf67-3b8c-7cc2-b48e-438cc9af5fdb@intel.com>
 <52826c35-eba1-40fb-bfa9-23a87400bfa4@lunn.ch>
In-Reply-To: <52826c35-eba1-40fb-bfa9-23a87400bfa4@lunn.ch>
From: Willem de Bruijn <willemb@google.com>
Date: Fri, 19 May 2023 14:42:50 -0400
Message-ID: <CA+FuTSfJuVGgU6ce_SSErXUYc584OEgwk=PQS7beu2Tj5Wnu-w@mail.gmail.com>
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Emil Tantilov <emil.s.tantilov@intel.com>, intel-wired-lan@lists.osuosl.org, 
	shannon.nelson@amd.com, simon.horman@corigine.com, leon@kernel.org, 
	decot@google.com, jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, "Singhai, Anjali" <anjali.singhai@intel.com>, 
	"Orr, Michael" <michael.orr@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 2:22=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +config IDPF
> > +     tristate "Intel(R) Infrastructure Data Path Function Support"
> > +     depends on PCI_MSI
> > +     select DIMLIB
> > +     help
> > +       This driver supports Intel(R) Infrastructure Processing Unit (I=
PU)
> > +       devices.
> >
> > It can be updated with Intel references removed when the spec becomes
> > standard and meets the community requirements.
>
> Is IPU Intels name for the hardware which implements DPF? I assume
> when 'Intel' is dropped, IPU would also be dropped? Which leaves the
> help empty.
>
> And i assume when it is no longer tied to Intel, the Kconfig entry
> will move somewhere else, because at the moment, it appears to appear
> under Intel, when it probably should be at a higher level, maybe
> 'Network device support'? And will the code maybe move to net/idpf?

This has come up before.

"Drivers are organized by the vendor for better or worse. We have a
number of drivers under the "wrong directly" already. Companies merge /
buy each others product lines, there's also some confusion about common
IP drivers. It's all fine, whatever."


https://lore.kernel.org/netdev/20230414152744.4fd219f9@kernel.org/

