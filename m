Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A468A8CC
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfHLVAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:00:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38841 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfHLVAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:00:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so105789482wrr.5;
        Mon, 12 Aug 2019 14:00:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NZE7gxGeoCir/+Hfqml4ihIDyfwgVKWckPdmovjOEYs=;
        b=oEql7aVdyfMmemmh5fcs9k9Hshch5Tz3oPsF1kQ4wEfaUqtg/mpc9xU2RK134KdLTr
         nZCsxCPXEDyU4yQzVzJwfZDdd+hh4PkhiI4g0pPxvGVOWBmY5QghdMgE2GBqmUdaPiHV
         oWsVvaRKZwYOV1/LmKoY/l/moJ1/LNT2LqiMf6UfRZkYGbzRNarxewx4RGzR+zJqCs00
         H4whjeovuQJG/VTpMbdvDbdMxd6hyJrkH38NPdJa8L7o84xXauA2kniUKZUBFvNbBVY0
         DPG2vYrzl92MkfcxAUPaoiYTmJnApVHnErYEkhbL17JB5b4TLNGZn/C4WqWbaNaje5dI
         +zsg==
X-Gm-Message-State: APjAAAXPB2Vq/slrmzl9IjzmIuRCchgYfk0rvt7fqakjxKpZCrjTKMDS
        PYwQAjUzgpg6cEEaRN4Bu3OBgcW+3SI=
X-Google-Smtp-Source: APXvYqwZIENuhetBQFWDkGbLZGQwjmnmtJwGSJ8aLLbVv6q00tpIINFgPIuZbSt++bfrwgo+lXVc5w==
X-Received: by 2002:adf:ce05:: with SMTP id p5mr42381291wrn.197.1565643638256;
        Mon, 12 Aug 2019 14:00:38 -0700 (PDT)
Received: from [10.68.32.192] (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.gmail.com with ESMTPSA id f23sm510930wmj.37.2019.08.12.14.00.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:00:37 -0700 (PDT)
Subject: Re: [PATCH 0/7] Add definition for the number of standard PCI BARs
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190811150802.2418-1-efremov@linux.com>
 <20190812090639.GX56241@e119886-lin.cambridge.arm.com>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <4a8e0b95-192b-335e-653a-5a973f18ba2e@linux.com>
Date:   Tue, 13 Aug 2019 00:00:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812090639.GX56241@e119886-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.08.2019 12:06, Andrew Murray wrote:
> 
> Hi Denis,

Hi!

> 
> You could also fix up a few cases where the number of BARs is hard coded in
> loops, e.g.
> 
> drivers/pci/controller/pci-hyperv.c - look for uses of probed_bar in loops
> drivers/pci/pci.c - pci_release_selected_regions and __pci_request_selected_regions
> drivers/pci/quirks.c - quirk_alder_ioapic
> 

Thanks for pointing me on that. I will take this into account in v2.

Denis
