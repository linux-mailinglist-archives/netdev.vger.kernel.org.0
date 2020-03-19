Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3CA18C0AF
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgCSTrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:47:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:56401 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgCSTrB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 15:47:01 -0400
IronPort-SDR: Po8Z/pzT4ZyzATKERnc1WJgjSBvnAiGgTZcOVGdH2Sbi5IJn62f1jnNywVcCqPEXMi+J7xo/x9
 wwy0XEFxe94Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 12:46:58 -0700
IronPort-SDR: a6SaYj/xeKftbSen3LWYA6qWR9ApLeeTa+v5cjiVyF9UB9Q7xyMMQqIfWGC7lVjo5Zg0E1J0nu
 0ljRFqFI0wdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,572,1574150400"; 
   d="scan'208";a="391910291"
Received: from oamor-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.182.181])
  by orsmga004.jf.intel.com with ESMTP; 19 Mar 2020 12:46:51 -0700
Date:   Thu, 19 Mar 2020 21:46:50 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Waiman Long <longman@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
Subject: Re: [PATCH v5 2/2] KEYS: Avoid false positive ENOMEM error on key
 read
Message-ID: <20200319194650.GA24804@linux.intel.com>
References: <20200318221457.1330-1-longman@redhat.com>
 <20200318221457.1330-3-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318221457.1330-3-longman@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 06:14:57PM -0400, Waiman Long wrote:
> +			 * It is possible, though unlikely, that the key
> +			 * changes in between the up_read->down_read period.
> +			 * If the key becomes longer, we will have to
> +			 * allocate a larger buffer and redo the key read
> +			 * again.
> +			 */
> +			if (!tmpbuf || unlikely(ret > tmpbuflen)) {

Shouldn't you check that tmpbuflen stays below buflen (why else
you had made copy of buflen otherwise)?

/Jarkko
