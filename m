Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFCB18C52B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCTCH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:07:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:21301 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCTCH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 22:07:27 -0400
IronPort-SDR: cERMwsobxSgaDQ6DVukFbFlA9Fbaqs3xVhQ2UmtyLWIUq8Z4XF6Hx6HNyMdqy6qEHVoDMfI77F
 6q/O4k1l1jQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 19:07:27 -0700
IronPort-SDR: WiEzzFWd7aTAoICAsN40XtyFpCM6ZL+d1ZkXNh3BJ3Vi1nV2R8/rxwplPDE8ycxCDCxG4UTI9x
 XiL+wxuMpEeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,282,1580803200"; 
   d="scan'208";a="245348348"
Received: from anakash-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.183.74])
  by orsmga003.jf.intel.com with ESMTP; 19 Mar 2020 19:07:18 -0700
Date:   Fri, 20 Mar 2020 04:07:17 +0200
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
Message-ID: <20200320020717.GC183331@linux.intel.com>
References: <20200318221457.1330-1-longman@redhat.com>
 <20200318221457.1330-3-longman@redhat.com>
 <20200319194650.GA24804@linux.intel.com>
 <f22757ad-4d6f-ffd2-eed5-6b9bd1621b10@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22757ad-4d6f-ffd2-eed5-6b9bd1621b10@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 08:07:55PM -0400, Waiman Long wrote:
> On 3/19/20 3:46 PM, Jarkko Sakkinen wrote:
> > On Wed, Mar 18, 2020 at 06:14:57PM -0400, Waiman Long wrote:
> >> +			 * It is possible, though unlikely, that the key
> >> +			 * changes in between the up_read->down_read period.
> >> +			 * If the key becomes longer, we will have to
> >> +			 * allocate a larger buffer and redo the key read
> >> +			 * again.
> >> +			 */
> >> +			if (!tmpbuf || unlikely(ret > tmpbuflen)) {
> > Shouldn't you check that tmpbuflen stays below buflen (why else
> > you had made copy of buflen otherwise)?
> 
> The check above this thunk:
> 
> if ((ret > 0) && (ret <= buflen)) {
> 
> will make sure that ret will not be larger than buflen. So tmpbuflen
> will never be bigger than buflen.

Ah right, of course, thanks.

What would go wrong if the condition was instead
((ret > 0) && (ret <= tmpbuflen))?

/Jarkko
