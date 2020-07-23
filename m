Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B8122B42A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgGWRIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbgGWRIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 13:08:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D856EC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:08:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so3410090pgc.5
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q19gKFYYro2MzDbwsCSZ3gx/BPZCyC9WtgguNV40tXU=;
        b=RchmPBg2T4iVvYBHaRA5y5SN68JSU2SEkPxuV49QYJrc5pfbC1J+k9PjsOOq8Rg7a1
         WqMHyJhCNgNpXDBBjtQq22xGI9hJt8LIMNSpUgKpL/AGk0u7XmT6iiphZ8SQPIhPC1p/
         RnwMARDty8hLpEY+hFN1btotFUXxTcWIcrs9f6/WDJuoPR48KGHHUhsoAqoXUdWq4xlU
         3N5BOW7Gw3X3CuJk7EIQO9xw7G5at0j7/rw2Zm4N9aRKghwRh936fdDocsbT8mo7EJLD
         O37vY0fXJEbEzUTz47cUQJLqWDnV5urRbU/OjieaSxtMadED17//fueOxTsNIbg6TPCr
         X24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q19gKFYYro2MzDbwsCSZ3gx/BPZCyC9WtgguNV40tXU=;
        b=C7vCBL3mTgKCs1APG4YdTKz9wU5N2Lfi5ftusAz6PUAfyzgvTcUln92JQrPEaHdWJ+
         6qQVWx1zrT6L+1j7kOZ53/TISpMZEdGklNi5wip708QUhE9ZT3WoywUoJqLDFVvg49/5
         v46c8+wwOmbi8gvd9dGtbGE92VlC5jmvXFbKPgsIfljIqGGMJOQIu6oKW/Qrr6K/WT5R
         DBnslBlzBqYxns4bkCHeP8dWIYb36scaYzxlLDTgcOFEgX/Ac0JU8MTsadULpUfD4+4n
         d9mLvCogCMbPO8c0/2/eUijYdztMjclI511HWbVoFggQQOf0jiFUK/kmjp944aPfREql
         PLZg==
X-Gm-Message-State: AOAM530A87DGWSY9Y+8o6w7qvNMXj/+iuAjYAHCsReSHQMtCgISbrDSp
        uXSZ7wexQZnX2MDt7NbqchE=
X-Google-Smtp-Source: ABdhPJyOxncPv5JAYnet+jYmelxDJ1jphzFya6lptXgDact7rKoJEo3W5l1yuP4wVVD0eG6TlwRkwQ==
X-Received: by 2002:a62:a217:: with SMTP id m23mr4956559pff.291.1595524125364;
        Thu, 23 Jul 2020 10:08:45 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d14sm3577147pjc.20.2020.07.23.10.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 10:08:44 -0700 (PDT)
Date:   Thu, 23 Jul 2020 10:08:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/2] ptp: Add generic header parsing function
Message-ID: <20200723170842.GB2975@hoboy>
References: <20200723074946.14253-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723074946.14253-1-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kurt,

On Thu, Jul 23, 2020 at 09:49:44AM +0200, Kurt Kanzenbach wrote:
> in order to reduce code duplication in the ptp code of DSA drivers, move the
> header parsing function to ptp_classify. This way the Marvell and the hellcreek
> drivers can share the same implementation. And probably more drivers can benefit
> from it. Implemented as discussed [1] [2].

This looks good.  I made a list of drivers that can possibily use this helper.

Finding symbol: PTP_CLASS_PMASK

*** drivers/net/dsa/mv88e6xxx/hwtstamp.c:
parse_ptp_header[223]          switch (type & PTP_CLASS_PMASK) {

*** drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c:
mlxsw_sp_ptp_parse[335]        switch (ptp_class & PTP_CLASS_PMASK) {

*** drivers/net/ethernet/ti/am65-cpts.c:
am65_skb_get_mtype_seqid[761]  switch (ptp_class & PTP_CLASS_PMASK) {

*** drivers/net/ethernet/ti/cpts.c:
cpts_skb_get_mtype_seqid[459]  switch (ptp_class & PTP_CLASS_PMASK) {

*** drivers/net/phy/dp83640.c:
match[815]                     switch (type & PTP_CLASS_PMASK) {
is_sync[990]                   switch (type & PTP_CLASS_PMASK) {

*** drivers/ptp/ptp_ines.c:
ines_match[457]                switch (ptp_class & PTP_CLASS_PMASK) {
is_sync_pdelay_resp[703]       switch (type & PTP_CLASS_PMASK) {

> @DSA maintainers: Please, have a look the Marvell code. I don't have hardware to
> test it. I've tested this series only on the Hirschmann switch.

I'll test the marvell switch with your change and let you know...

Thanks,
Richard
