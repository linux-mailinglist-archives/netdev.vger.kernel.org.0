Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21620425D5B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbhJGUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241991AbhJGUbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:31:53 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB61AC061570;
        Thu,  7 Oct 2021 13:29:58 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r18so27787355edv.12;
        Thu, 07 Oct 2021 13:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/j6SIVjca5oFQGCoksjBCyHVLuFBGRC7s2+Csc09TLc=;
        b=lmms50BUytqGRHsvSDFgMyhziIPoqPIFe1Yihz2EnmTV44OQr0/sRQvZfdZ+LG/yCN
         hOgbs5bVN32umgsdKIJVCL84j9FIQODW3rWLDVezUUYV2Xhh+wREitZ79ChyWXbjpK7z
         ujO1MaQ2Fuz/qClLB74PJh3k9t8qA5WFblJO3wH9fiM7vsW0lRFtDekWr36puLDdS8oR
         fuaM9XHe0zbRsOiUJh63PJrHRy/dATJLBwsuKJlniZ06SujOVgK5y00SBo/Wlt/lrqA5
         tXdzt9skLxW24WQgVNTU7hqdRqMN2ON+2+CKu3Gh8UFvhurtLevUO7xIanychVgnBHtz
         l4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/j6SIVjca5oFQGCoksjBCyHVLuFBGRC7s2+Csc09TLc=;
        b=yzxaalyr0YX9iCFN0CKhJN/c49ZwFSof5Sey+CnzAGmo5oaaj6wn/ozDYLgUlIjfft
         +CPetVdzAOYZcgnWZGStYPzCRnIftmy56t9V/llVfFTYNq6Dzu73IdJkaNK2xcbOBM1p
         786r2DYcCe1o+r4x1ORzsIpbjSjhri/RtU0kr/r5QGjcVNO5j6YdDXG0D+8ahBZLI+xZ
         PP3RrSJsuttIUdA/+DotcEp/6Xnx9IcJQle4iu/eZct3JiNumBhKTK3M/vbm17hkBmqV
         NcQ+Lw/P2qba8dwephQCtr3eXiVppna+ImiS2zI/n+9niIzvjVmdcizelxkMBdk8mluw
         pYog==
X-Gm-Message-State: AOAM533tN44/OUrrtdnVzVdGd94+Kyujr3Sw4Nk13npFED7PnxFmzD1N
        HoAfg8szoYV6PMt9Xn09PYE=
X-Google-Smtp-Source: ABdhPJwqIjcQ8cwFRkmJq3b+tVjVG48iJwKh2gpZMI6ewwR990dt4U0YZWh+ZgBLLUuzKhaHZOt7PQ==
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr8028043ejb.376.1633638597258;
        Thu, 07 Oct 2021 13:29:57 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id h9sm183167edr.67.2021.10.07.13.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:57 -0700 (PDT)
Date:   Thu, 7 Oct 2021 23:29:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 09/10] net: dsa: microchip: add support for
 fdb and mdb management
Message-ID: <20211007202955.vwasddyxouqy5ccw@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-10-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007151200.748944-10-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 08:41:59PM +0530, Prasanna Vengateshan wrote:
> Support for fdb_add, mdb_add, fdb_del, mdb_del and
> fdb_dump operations. ALU1 and ALU2 are used for fdb operations.
> 
> fdb_add: find any existing entries and update the port map.
> if ALU1 write is failed and attempt to write ALU2.
> If ALU2 is also failed then exit. Clear WRITE_FAIL for both ALU1
> & ALU2.
> 
> fdb_del: find the matching entry and clear the respective port
> in the port map by writing the ALU tables
> 
> fdb_dump: read and dump 2 ALUs upto last entry. ALU_START bit is
> used to find the last entry. If the read is timed out, then pass
> the error message.
> 
> mdb_add: Find the empty slot in ALU and update the port map &
> mac address by writing the ALU
> 
> mdb_del: find the matching entry and delete the respective port
> in port map by writing the ALU
> 
> For MAC address, could not use upper_32_bits() & lower_32_bits()
> as per Vladimir proposal since it gets accessed in terms of 16bits.
> I tried to have common API to get 16bits based on index but shifting
> seems to be straight-forward.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +static int lan937x_port_fdb_dump(struct dsa_switch *ds, int port,
> +				 dsa_fdb_dump_cb_t *cb, void *data)
> +{

> +			if (alu.port_forward & BIT(port)) {
> +				ret = cb(alu.mac, alu.fid, alu.is_static, data);

A bit strange that you report the FID and not the VID here.

> +				if (ret)
> +					goto exit;
> +			}
> +		} while (lan937x_data & ALU_START);
> +
> +exit:
> +		/* stop ALU search & continue to next ALU if available */
> +		ret = ksz_write32(dev, REG_SW_ALU_CTRL(i), 0);
> +	}
> +
> +	mutex_unlock(&dev->alu_mutex);
> +
> +	return ret;
> +}
