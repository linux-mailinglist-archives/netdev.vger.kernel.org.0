Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3BBF9A0F4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbfHVURb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:17:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45291 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730203AbfHVURb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:17:31 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so6298611qki.12
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=bjuxs0vMDpJVM7vpA+KCxWnYLvBAgSP95cf3UX6AnSQ=;
        b=h2du/Utyn5KPte2E2mmJ6y2Iz/ID3cl8j0Myo89jTVmpaKGilHmKeJCSvRFjHoLC1n
         QsQzMZ4uy90kC4C7FGMS0o48GfiH1srK0l5/+tPkd7NX+3TZfD6A7zUNeq1NsSeAH39c
         Wxrf60K88yAN7ZAzn6jJ3gWAwEJ6700sYwx+oyZN8raDjZtq0nvI2ypS5pskAndDASF5
         MgIuqdubGGaBo/Me6gLYk/YpPhTki61dlbF/OTuw0wD/YATolDU0mb0E+C6pUCch2UiN
         GG/IiBrXh/sXusmE+lZFfH0uQCJ+L4Joad2PU6f72FSTMrumvScLBwpuBkF3GWBLX7CO
         Uo8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=bjuxs0vMDpJVM7vpA+KCxWnYLvBAgSP95cf3UX6AnSQ=;
        b=jewW8nQclJAJAi6YvHkoVdo/6JWJmW18MYW4JQ+FZaOD3/Qi966yHwVuvARVxqT3I8
         pXFfULEGh8arXxHKCueOm89omOJUKtBdg4TklQu8HsDhY7XHB1NgomJ4oo5ji9yWec7o
         M9XCjDnf4yqHVK2XsntljVo1YUzOUU8u/npe54dMXJP2YWTWdt23NEJ0SXnee6KlpeHN
         +GxnPmm1EWuAlzgDfFFY96o7VTOdK2HEu/zViA3Qfs4OstZc5YARxaYE4sB9mu4GVPbL
         Es2xeSmPeQrGDLSg3bcj3yGE8LvT2Sc93jIcIFNWfJpKi740HMOTYFy93jzthIv+WzW6
         XatQ==
X-Gm-Message-State: APjAAAW2qj2HraiVKmu16lnXHj6EEn5a58PmVY0NkxuBXs2rOcyRlda3
        uDKJwvMKJOUuN2/DknvnyV7Zn1WL
X-Google-Smtp-Source: APXvYqzwuK8ZRJz5OOsIcCDkstHBUGVwsefj60yq/OhO7moWwjWGwGlCrxmMFHA+ezncQhdv71VqAg==
X-Received: by 2002:a37:4a0b:: with SMTP id x11mr829198qka.395.1566505050015;
        Thu, 22 Aug 2019 13:17:30 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id a67sm385516qkb.15.2019.08.22.13.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:17:29 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:17:28 -0400
Message-ID: <20190822161728.GB1471@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com
Subject: Re: [PATCH net-next] net: dsa: remove bitmap operations
In-Reply-To: <20190821062423.18735-1-vivien.didelot@gmail.com>
References: <20190821062423.18735-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 02:24:23 -0400, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> The bitmap operations were introduced to simplify the switch drivers
> in the future, since most of them could implement the common VLAN and
> MDB operations (add, del, dump) with simple functions taking all target
> ports at once, and thus limiting the number of hardware accesses.
> 
> Programming an MDB or VLAN this way in a single operation would clearly
> simplify the drivers a lot but would require a new get-set interface
> in DSA. The usage of such bitmap from the stack also raised concerned
> in the past, leading to the dynamic allocation of a new ds->_bitmap
> member in the dsa_switch structure. So let's get rid of them for now.
> 
> This commit nicely wraps the ds->ops->port_{mdb,vlan}_{prepare,add}
> switch operations into new dsa_switch_{mdb,vlan}_{prepare,add}
> variants not using any bitmap argument anymore.
> 
> New dsa_switch_{mdb,vlan}_match helpers have been introduced to make
> clear which local port of a switch must be programmed with the target
> object. While the targeted user port is an obvious candidate, the
> DSA links must also be programmed, as well as the CPU port for VLANs.
> 
> While at it, also remove local variables that are only used once.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

David, I've included this patch into a new series with other related patches,
you can ignore this one now.


Thanks,

	Vivien
