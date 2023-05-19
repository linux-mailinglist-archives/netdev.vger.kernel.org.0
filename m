Return-Path: <netdev+bounces-3918-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F09397098B7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:50:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D97611C21272
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E53DDD8;
	Fri, 19 May 2023 13:50:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C62BDDD0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:50:49 +0000 (UTC)
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AECFE6E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:50:22 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-517ca8972c5so278999a12.0
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684504222; x=1687096222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uq5sT4A1vpXW+fBPDc6HcD/EaWLce9Kt4flpPckP7Us=;
        b=gsFgZb+JKyvFmE3qx9ArjoTb8ENDFMHaNXs51SDCjyo+KIEpHuavh0b0eRGh5ltvkq
         GANHlhlWn2Ds7XrNKMFeSgm7qepycAq0JCmLn9RidaggK6hqPfEx8Ngd1cuz7YJ7me0a
         sMQTajfY1PLRDXubWJSbd4co+E+yqCgO0PT/j9k7p6QmCcIYyaLm2qLm9to0g2Uoj8t1
         ug8w+KJzV4WZW62ctVAZOym4s98pKFXfRdja0AhVuB/WhRQEFSff+ddqVqXtU9sPkshp
         RRkFLf1HV4z84aC0h4m/mD5B+9ElOwpY4c7no1UCrlMi4GSCOdppv+S8o0MbQD/dwLCc
         gOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684504222; x=1687096222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uq5sT4A1vpXW+fBPDc6HcD/EaWLce9Kt4flpPckP7Us=;
        b=GXc0nOo/m4K8XeF5rAOSR2NorXIYKbOp+G+B2xJ59pS2182l1RKST/ppIBKR4SqKM8
         hDcxLDDZNvUvfKf2bskXmao0NbpH6zAfksFf5RQ5hqbNnW4AnDb+KdFQzvOBGW2GBuRy
         SrGg9O7776krvG3CtDnlQ9L7LFPuaQLxGBKps58NfpctXmsgHfw06KdzO/b/D1BIHs4Q
         PByMNByqaDjEBRpWYzcORLS1r4dV0l6UjloK5BRSBZKc015dOEmzCvJ/iiunbCsucc8Z
         gbGnFalhNsosEsT6cqrcqn/oDlEbl0z8MRs2gcjBkHCjNINh8PWS9JZ/krKowwF+Klq8
         ANgA==
X-Gm-Message-State: AC+VfDzvUOFE0bwQgVZbwE5oWauqebjfKfw5ZiksBVhxVj0z9yCKHNfT
	QYNa8SjZN4opbmoIW4C36sM=
X-Google-Smtp-Source: ACHHUZ5P38vZmcQ4Jl9/m9AC9UUiiwr82V6pJya0cTzte+ppaK4Lh0AUWteZHLe+QrbqWGCwZU86fA==
X-Received: by 2002:a17:903:32c3:b0:1ae:3dcf:ecf3 with SMTP id i3-20020a17090332c300b001ae3dcfecf3mr2870858plr.6.1684504221851;
        Fri, 19 May 2023 06:50:21 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902e74c00b001a6d4ffc760sm3444282plf.244.2023.05.19.06.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 06:50:21 -0700 (PDT)
Date: Fri, 19 May 2023 06:50:19 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
	vadim.fedorenko@linux.dev, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <ZGd+m1MQPuL3S1V6@hoboy.vegasvil.org>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <5f9a1929-b511-707a-9b56-52cc5f1c40ba@intel.com>
 <ZGVZXTEn+qnMyNgV@hoboy.vegasvil.org>
 <32cb61b3-16f6-5b2b-4d57-5764dc8499cc@intel.com>
 <a5435c39-438c-434c-a0b5-73bf6ecd3a99@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5435c39-438c-434c-a0b5-73bf6ecd3a99@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:50:42PM +0200, Andrew Lunn wrote:

> I would actually say there is nothing fundamentally blocking using
> NETWORK_PHY_TIMESTAMPING with something other than DT. It just needs
> somebody to lead the way.

+1
 
> For ACPI in the scope of networking, everybody just seems to accept DT
> won, and stuffs DT properties into ACPI tables.

Is that stuff mainline?

> For PCI devices, there
> has been some good work being done by Trustnetic using software nodes,
> for gluing together GPIO controllers, I2C controller, SFP and
> PHYLINK.

mainline also?

> It should be possible to do the same with PHY timestampers.

Sounds promising...

Thanks,
Richard




