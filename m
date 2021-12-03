Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D575467AB4
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 16:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381932AbhLCQCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:02:09 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39485 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381936AbhLCQBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:01:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D5DC2580299;
        Fri,  3 Dec 2021 10:58:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 03 Dec 2021 10:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JjPqo0
        7GzclQowIXgO11ef1Z0XrbTc75Ybow2HLgDHM=; b=f4shhmDNENyDIebbipMSlH
        ZDnY9Qay2V4O8BXWtRSo/7eU3xDc0vBMjSuTuSj0ailJOl9sIASZGKUiHgCMVPNm
        fVdUcOWgvvMP2w0HCG1jVP8bO65EfZFVHuRZ4lZ5qU8t1Bp6OWnXLPGrq3dbUTBA
        1KuxcogyhdAY4VNH2JQW84eWLB3y4+TRnr/dBvzTcnQV2o5cpo7RWM6xFDP9wl1C
        4PE0q9VRN3Bg5F9ETZIQ1ZA3vjedBaIbuFxdoKqhzs2Z7tlH+2prWtK1pXru0srq
        IBr5kpvqCzQTkULEUR3IssG1lUXVd0bPifWPKX1KUpFBSWqXP4WM/Rlg1PPPqXgQ
        ==
X-ME-Sender: <xms:oD6qYd8-8iXaSgjmR-3yWDwQ9ES9WB1nk8nwwJWlk-FnwiwBBrRwvw>
    <xme:oD6qYRs7K2ycOb1iLZ3nscl1P6KoRYe3LV9tioru5qpZF4hFwQSITCJMjgfKK9yH8
    2tLa94rjQgUL9Y>
X-ME-Received: <xmr:oD6qYbDExsN3C_3mTW8t16u5-uaxEbr4d62EFMx2hFoEbPLispkPVoHJJCtXnnnFYODlp_E1lOO3MdB1NB4Uu5fuHchkVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieejgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:oD6qYRdLeye03_rgc5cL3zP7pLEfKRfZwqSkL36AvB2ysANkSLz4CA>
    <xmx:oD6qYSNnbfx2ESeHx3Zao7XWS76_Q2NnJULK88qFPKIe-ofNeziHdg>
    <xmx:oD6qYTn4aLShaqiV6UJ9DP_cXopWd_4jbOr1h3NkyY_sosidcAj0Lw>
    <xmx:oT6qYTmLAbk0-3K-u7gNJcTljd7ZhtXJxMhgpGSR16Vbc-hkfIG3qg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Dec 2021 10:58:23 -0500 (EST)
Date:   Fri, 3 Dec 2021 17:58:20 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Message-ID: <Yao+nK40D0+u8UKL@shredder>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <87pmqdojby.fsf@nvidia.com>
 <MW5PR11MB581202E2A601D34E30F1E5AEEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR11MB581202E2A601D34E30F1E5AEEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 02:55:05PM +0000, Machnikowski, Maciej wrote:
> If you have 32 port switch chip with 2 recovered clock outputs how will you
> tell the chip to get the 18th port to pin 0 and from port 20 to pin 1? That's
> the part those patches addresses. The further side of "which clock should the
> EEC use" belongs to the DPLL subsystem and I agree with that.
> 
> Or to put it into different words:
> This API will configure given quality level  frequency reference outputs on chip's
> Dedicated outputs. On a board you will connect those to the EEC's reference inputs.

So these outputs are hardwired into the EEC's inputs and are therefore
only meaningful as EEC inputs? If so, why these outputs are not
configured via the EEC object?

> 
> The EEC's job is to validate the inputs and lock to them following certain rules,
> The PHY/MAC (and this API) job is to deliver reference signals to the EEC. 
> 
