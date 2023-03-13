Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454266B7A5A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCMOat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjCMOap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:30:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EF134008;
        Mon, 13 Mar 2023 07:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678717844; x=1710253844;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=2A5vXcR9dVDQtHTdsgDzpaUet920wYeoo1FeiQYkThg=;
  b=koRx0upe2e6SBdfahHaT2sSHlqPiWEO6y/N5i/5AbRtxA3HEXQtZNlDG
   u+2q9UfU4Qi6ttfT9TqWtkvsY0/MGrkXkW0YSeVQa1prXkrsJoDq223Az
   /lAyMutULsAm9vJQFJbcYHnWwEdaMvf8+kbdDWtO49NJkwfaf0aNmwTqw
   QDCQN+LVF/Ty3QWYjbLJkGX2r28P4ZTfs/cB0JmoE+zK8j57dkJ3OShJf
   Q5xl0Y1IwkosZfXNzHjwMWLgHd5wtvnuEByTQA6nmJ2VMd1sKHQvMPZMI
   /lxHi+A3Fp4rs1FsHTKbqxY26qy+fwlRIO9jOwZaOKogtIl9Uy/PqNubM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337180473"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="337180473"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 07:30:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="678701605"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="678701605"
Received: from etsykuno-mobl2.ccr.corp.intel.com ([10.252.47.211])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 07:30:37 -0700
Date:   Mon, 13 Mar 2023 16:30:34 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: RE: [EXT] Re: [PATCH v9 3/3] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
In-Reply-To: <AM9PR04MB8603EB5DA53821B12E049649E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
Message-ID: <17a9ffd1-342c-2cf1-2a57-7fabe1fce8b8@linux.intel.com>
References: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com> <20230313140924.3104691-4-neeraj.sanjaykale@nxp.com> <b28d1e39-f036-c260-4452-ac1332efca0@linux.intel.com> <AM9PR04MB8603EB5DA53821B12E049649E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1280341670-1678717842=:2573"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1280341670-1678717842=:2573
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 13 Mar 2023, Neeraj sanjay kale wrote:

> > 
> > Thanks, looks okay to me except this one I just noticed while preparing this
> > email:
> > 
> > > +MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");
> > 
> > I don't think version numbers belong to the module description.
> > 
> I was asked to remove the MODULE_VERSION("v1.0") line in my v2 patch, hence kept it in the description.
> https://patchwork.kernel.org/project/bluetooth/patch/20230130180504.2029440-4-neeraj.sanjaykale@nxp.com/
> 
> Please suggest me the right way to put the version string in this driver.

I think Leon meant you should just drop the version altogether (since this 
is new code).

-- 
 i.

> > Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > 
> > 
> > --
> >  i.
> 
> Thank you again for reviewing this patch. :D
> 
> -Neeraj
> 

--8323329-1280341670-1678717842=:2573--
