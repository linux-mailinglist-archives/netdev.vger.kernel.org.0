Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3108B58D04
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfF0VZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:25:41 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39922 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0VZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:25:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so4108365qta.6
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ElQV/u013YOYWC11HkhStHYWBt87I6cc9bNTnf9Bdm4=;
        b=T36dbXKHxrwS69Q8gWHCjPoYPosyIUxHjwSqCIVOfyO4WiE82BX195TJ72d+IEhMjX
         26FLfVumUjwSrLC7/ffZG1PiBC2KqW2YSpJPtRbZe132rdMRXDmxSJW9pyJEvZV5M1wQ
         nCvPyoCxtEH7xXAwwUhUM+3YPoWpZZSU8tjNe4uRm+0+q8WfK3e9HlVE/AwxEXe5y39o
         iFWiE9nwMPbJ8J8EREMeFlFN/csiLebu41M1Uq4EsMCwV2pFzpPWyegu1brWuuPU75Dl
         uU41vf4l0tKzEgOyZA/6tXwIZnEWbMzlnyi8Soe3cZeV0A7B8/bLIUT+gvV/87HcYs9Z
         uqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ElQV/u013YOYWC11HkhStHYWBt87I6cc9bNTnf9Bdm4=;
        b=DGtqs+c/bKAwSM2EGe0dgdKWVgUv0oQkS+cvSoPC8r6uRdmpSDyG2rTMY2P1+Q9efk
         T1newoko1ZoR+if0SGHPhEv9KUzwNuZ86aMzNmsm96d5SgORBJTghag/4cr4l9LirUyF
         WIh+es438TEApKZawLOZ9cP66DB4qJ7yAMR7NwZ+jDnifq7e2Z0d5lk0670VtRlApDrd
         1A6kEv/J0XubABkE8EXbm5EheODp2wt6s7aQk92k0yWxwNqbl0ydCUfyVVPMbxkdiOBN
         6RMQ6YEesz/CN9P0s7y2J8uwYsz5bz2pdvx9aP3Eel7p75gmBbgGANyrCp+eWoDRvTWb
         Yo+w==
X-Gm-Message-State: APjAAAX1XSsKpIXHl1I6h5DZx+PZsxt5UVAiVzTsAoQ7ktWVrAtod85d
        WvMUvJQ3u8AGcEv67Y0cSPSttg==
X-Google-Smtp-Source: APXvYqwS3c8fznhmB0uVN5y7M83pNsjbPuQ5eVwA9n13yNBMIwZrFANycsCBrJoFsUI+f0arYexlmQ==
X-Received: by 2002:a0c:880b:: with SMTP id 11mr5066098qvl.185.1561670740197;
        Thu, 27 Jun 2019 14:25:40 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v17sm160765qtc.23.2019.06.27.14.25.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 14:25:39 -0700 (PDT)
Date:   Thu, 27 Jun 2019 14:25:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Laatz, Kevin" <kevin.laatz@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, bpf@vger.kernel.com,
        intel-wired-lan@lists.osuosl.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
Message-ID: <20190627142534.4f4b8995@cakuba.netronome.com>
In-Reply-To: <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
        <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
        <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 12:14:50 +0100, Laatz, Kevin wrote:
> On the application side (xdpsock), we don't have to worry about the user 
> defined headroom, since it is 0, so we only need to account for the 
> XDP_PACKET_HEADROOM when computing the original address (in the default 
> scenario).

That assumes specific layout for the data inside the buffer.  Some NICs
will prepend information like timestamp to the packet, meaning the
packet would start at offset XDP_PACKET_HEADROOM + metadata len..

I think that's very limiting.  What is the challenge in providing
aligned addresses, exactly?
