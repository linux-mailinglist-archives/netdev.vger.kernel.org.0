Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C2ADCE4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 09:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfD2HcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 03:32:05 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:40722 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfD2HcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 03:32:04 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hL0lK-00053O-Qd; Mon, 29 Apr 2019 09:31:43 +0200
Date:   Mon, 29 Apr 2019 09:31:37 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>
cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 12/15] kvm/vmx: Emulate MSR TEST_CTL
In-Reply-To: <87ef9a01-fc99-20be-ec20-2c65e6a012a1@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1904290929570.1626@nanos.tec.linutronix.de>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com> <1556134382-58814-13-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1904250931020.1762@nanos.tec.linutronix.de> <7395908840acfbf806146f5f20d3509342771a19.camel@linux.intel.com>
 <alpine.DEB.2.21.1904280903520.1757@nanos.tec.linutronix.de> <87ef9a01-fc99-20be-ec20-2c65e6a012a1@linux.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Apr 2019, Xiaoyao Li wrote:
> On 4/28/2019 3:09 PM, Thomas Gleixner wrote:
> > On Sat, 27 Apr 2019, Xiaoyao Li wrote:
> > > Indeed, if we use split lock detection for protection purpose, when host
> > > has it enabled we should directly pass it to guest and forbid guest from
> > > disabling it.  And only when host disables split lock detection, we can
> > > expose it and allow the guest to turn it on.
> > ?
> > > If it is used for protection purpose, then it should follow what you said
> > > and
> > > this feature needs to be disabled by default. Because there are split lock
> > > issues in old/current kernels and BIOS. That will cause the existing guest
> > > booting failure and killed due to those split lock.
> > 
> > Rightfully so.
> 
> So, the patch 13 "Enable split lock detection by default" needs to be removed?

Why? No. We enable it by default and everything which violates the rules
gets what it deserves. If there is an issue, boot with ac_splitlock_off and
be done with it.

Thanks,

	tglx
