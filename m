Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F78F611AA1
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 21:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJ1THU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 15:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ1THS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 15:07:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A28F13A7FB;
        Fri, 28 Oct 2022 12:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AB9762A0B;
        Fri, 28 Oct 2022 19:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C90EC433D6;
        Fri, 28 Oct 2022 19:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666984037;
        bh=ervC6ARXQQ75MdsA8OL4ZgPAvhRgLXYEJOmpIVIk9PM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qwa3QUBIxYIkqpBLAMz/CoVKnJAFJXovNuQS/JLnNFs/AG7S6ecUM7qigbU1RR3mW
         rt/2eRXhC8dL7JbaSkpNm8nllgm2HFuBOv+1nLMJS/7cmDcLPHdW40S1TKCqM6rzw2
         SzwFkZGy39njtqwYKWE6GF9QrFEwJVEs++PZjg9WKLH9lh+L523Pv46M99D42iQvrH
         iADFqBUmfHsbxohiTk6yCF4w3S/iVC07TpjgYfmaQZp0UXZDoaAzcayuhjRG2KYRZS
         lUip+9CcEGBI66zyMMwQng3dPaWnM+EIWeoknK8oU5SXtUmKEcIPzHgPlWlrHb2ymi
         amolGhv3ciRLg==
Date:   Fri, 28 Oct 2022 12:07:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
Cc:     Vee Khee Wong <veekhee@apple.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Gan, Yi Fang" <yi.fang.gan@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>
Subject: Re: [PATCH net-next 1/1] stmmac: intel: Separate ADL-N and RPL-P
 device ID from TGL
Message-ID: <20221028120715.1dc12fc1@kernel.org>
In-Reply-To: <DM5PR11MB15935E3AF06794F523DB48C69D329@DM5PR11MB1593.namprd11.prod.outlook.com>
References: <A23A7058-5598-46EB-8007-C401ADC33149@apple.com>
        <DM5PR11MB15935E3AF06794F523DB48C69D329@DM5PR11MB1593.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 10:44:24 +0000 Sit, Michael Wei Hong wrote:
> This is to allow finer control on platform specific features for ADL and =
RPL.
> There are some features that ADL and RPL doesn=E2=80=99t support and TGL =
supports vice versa.

But if they are the same _right_ _now_ what's the point?
Please repost as part of a series which actually modifies
the contents.

Please remember not to top post on the ML.
