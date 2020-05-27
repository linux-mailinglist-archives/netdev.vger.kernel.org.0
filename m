Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98FE1E4F10
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgE0USn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:18:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:38104 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgE0USm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 16:18:42 -0400
IronPort-SDR: W1XjTE5sDntON+wI7rXVCjPdg/+Wrl2pgW8byO474MtIZAfay4u52StHrf2aVMXVPcige1qArp
 uxZb0v51CpLg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 13:18:36 -0700
IronPort-SDR: qeV5PBBxNf4PG6j60czYGz/sEH2PiYbFsCnkNHUep629TYZU9KCCpm8B4/ot2E4Hty17GmZJ9/
 o186E3VRD1yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="255903035"
Received: from tgarris-mobl.amr.corp.intel.com ([10.255.72.202])
  by orsmga007.jf.intel.com with ESMTP; 27 May 2020 13:18:36 -0700
Message-ID: <b51ee1d61dbfbb8914d29338918ba49bff1b4b75.camel@linux.intel.com>
Subject: Re: [net-next v4 11/12] ASoC: SOF: Create client driver for IPC test
From:   Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Date:   Wed, 27 May 2020 13:18:35 -0700
In-Reply-To: <20200520125611.GI31189@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
         <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
         <20200520125611.GI31189@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-20 at 09:56 -0300, Jason Gunthorpe wrote:
> On Wed, May 20, 2020 at 12:02:26AM -0700, Jeff Kirsher wrote:
> > +static const struct virtbus_dev_id sof_ipc_virtbus_id_table[] = {
> > +	{"sof-ipc-test"},
> > +	{},
> > +};
> > +
> > +static struct sof_client_drv sof_ipc_test_client_drv = {
> > +	.name = "sof-ipc-test-client-drv",
> > +	.type = SOF_CLIENT_IPC,
> > +	.virtbus_drv = {
> > +		.driver = {
> > +			.name = "sof-ipc-test-virtbus-drv",
> > +		},
> > +		.id_table = sof_ipc_virtbus_id_table,
> > +		.probe = sof_ipc_test_probe,
> > +		.remove = sof_ipc_test_remove,
> > +		.shutdown = sof_ipc_test_shutdown,
> > +	},
> > +};
> > +
> > +module_sof_client_driver(sof_ipc_test_client_drv);
> > +
> > +MODULE_DESCRIPTION("SOF IPC Test Client Driver");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
> > +MODULE_ALIAS("virtbus:sof-ipc-test");
> 
> Usually the MODULE_ALIAS happens automatically rhough the struct
> virtbus_dev_id - is something missing in the enabling patches?
Hi Jason,

Without the MODULE_ALIAS,  the driver never probes when the virtual bus
device is registered. The MODULE_ALIAS is not different from the ones
we typically have in the platform drivers. Could you please give me
some pointers on what you think might be missing?

Thanks,
Rajnani

