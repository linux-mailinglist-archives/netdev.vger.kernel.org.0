Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BB826998A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgINXPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:15:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:33172 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgINXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 19:15:31 -0400
IronPort-SDR: yWyUgg5iKqPlUJ0ZIndj3Dg6ItLumJByXrSvMMi77E5k59SvJDJpW1DzQM4GiZunLoVHsH2Y7g
 +KWzXzUGr7OQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160108185"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="160108185"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:15:30 -0700
IronPort-SDR: 2p1kgOciEdNE0f39W0bEuiyO13N9fGR3JZXdNFQ0+qf3lio8fpEjBKaTmmzzonQNK2a//M3iDX
 0Y91DGBYUw0w==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482532652"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.142.25]) ([10.252.142.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:15:30 -0700
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200908224812.63434-1-snelson@pensando.io>
 <20200908224812.63434-3-snelson@pensando.io>
 <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
 <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
 <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
 <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
Date:   Mon, 14 Sep 2020 16:15:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 10:56 AM, Jakub Kicinski wrote:
> IOW drop the component parameter from the normal helper, cause almost
> nobody uses that. The add a more full featured __ version, which would
> take the arg struct, the struct would include the timeout value.
> 
I would point out that the ice driver does use it to help indicate which
section of the flash is currently being updated.

i.e.

$ devlink dev flash pci/0000:af:00.0 file firmware.bin
Preparing to flash
[fw.mgmt] Erasing
[fw.mgmt] Erasing done
[fw.mgmt] Flashing 100%
[fw.mgmt] Flashing done 100%
[fw.undi] Erasing
[fw.undi] Erasing done
[fw.undi] Flashing 100%
[fw.undi] Flashing done 100%
[fw.netlist] Erasing
[fw.netlist] Erasing done
[fw.netlist] Flashing 100%
[fw.netlist] Flashing done 100%

I'd like to keep that, as it helps tell which component is currently
being updated. If we drop this, then either I have to manually build
strings which include the component name, or we lose this information on
display.

Thanks,
Jake
