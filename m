Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF4B82401
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfHER3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:29:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34382 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHER3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:29:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so33869515pgc.1;
        Mon, 05 Aug 2019 10:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vJ3mUAXnht9x3y+33TQvsi1uRE8B830UjJ3acIHYJ90=;
        b=oWl/1lDALfYW3GNKzb72LvF5n2rfGE0enQNzxE6b0rLyiJ3VNErVsxXSrfbm/45qk4
         cyaSArivKzICI7lIQgFMhybtu5dlL7Cg+ZgyIk2otckXySw6JJvmBteLmLVPhUZ+XaZG
         480pRyviX2sXNEUq+HAszcxEk8i+KJg2rtIh6r18ZTtv3guFhZLPIqDseSDuV5+i4UAr
         edzTcl6/7hETGCP/56txQZ80o0bq6ewdzgN1cvwXTkPj8MLgW15ZVGHkKIxUuUwIv7nV
         cIeWLYso1auz0xXqTHFz2sguFVk9Jkn+qy/+sSgNxpJZymdVlnGzsDTR9OIh1mEwgUHV
         i6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vJ3mUAXnht9x3y+33TQvsi1uRE8B830UjJ3acIHYJ90=;
        b=N79BJvVefi1pvxcslK/IQsvjo/+Uc7Ny35lPooygcWofu7AjDTE74UoF01m2DXGW2b
         +0Ar7JZs04R44lMfLw8rFraBUfdcm5HcJBPyU+/kyGZANgiL9k4lxiy7qd0Mr/8rIDpK
         QdScEFSC4YesnB/D0ZipGJSz3zEi/YG2AcASt88wv5tbyre56KMI2bOV6s+XxeIHgtal
         lU7+tLSwIuAKJvmh/wacPTyFLIb8PqMnLIISR9DuF4RGTOD3FQsSeLbRrG/+cHII7Eq4
         /RwSukuqJIgacZBg1qsSzHdExx+pxXaID+3/+TNW76VPek5Hg7r8JvljqkfvmTs9hmuj
         mr3g==
X-Gm-Message-State: APjAAAWx0iV1vu69zWjoHLkDsF4rPUc/VY+iocZ7ol5RW0IcB+LiqchT
        y0zOMPtok3VXMDXQpYIFQWU=
X-Google-Smtp-Source: APXvYqxX/G5NAcQkUPvp6TuQiwGWSETxu0bAFqSp4IyJw5OQcmt3zNt01++yFLv78lbrtnoYn1pqzA==
X-Received: by 2002:a62:1456:: with SMTP id 83mr74472713pfu.228.1565026162760;
        Mon, 05 Aug 2019 10:29:22 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id f12sm76047963pgo.85.2019.08.05.10.29.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 10:29:22 -0700 (PDT)
Date:   Mon, 5 Aug 2019 10:29:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
Message-ID: <20190805172920.GB1552@localhost>
References: <20190805082642.12873-1-hubert.feurstein@vahle.at>
 <20190805135838.GF24275@lunn.ch>
 <CAFfN3gVFjb0uaF_NSHSOZN2knNn7nK3ZKRnvZDSN9A=+1qa-+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFfN3gVFjb0uaF_NSHSOZN2knNn7nK3ZKRnvZDSN9A=+1qa-+A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:12:40PM +0200, Hubert Feurstein wrote:
> It got improved, but you still have the unpredictable latencies caused by the
> mdio_done-completion (=> wait_for_completion_timeout) in imx_fec.

Yes, that is the important point.

Please take a look at other mmi_bus.write() implementations and see if
you can place the timestamps into the mii_bus layer.

Thanks,
Richard
