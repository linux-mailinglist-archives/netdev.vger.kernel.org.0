Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A783A2569BA
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgH2SX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 14:23:56 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:53888 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728265AbgH2SXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 14:23:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 1D990182CED5B;
        Sat, 29 Aug 2020 18:23:51 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:966:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3865:3866:3867:3870:3872:4117:4385:5007:6742:6743:9036:10004:10848:11026:11658:11914:12043:12048:12297:12760:13439:14096:14097:14181:14659:14721:21080:21433:21627:21990:30025:30029:30046:30054:30055:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: humor54_0f10f2427080
X-Filterd-Recvd-Size: 6548
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sat, 29 Aug 2020 18:23:44 +0000 (UTC)
Message-ID: <0f837bfb394ac632241eaac3e349b2ba806bce09.camel@perches.com>
Subject: sysfs output without newlines
From:   Joe Perches <joe@perches.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Denis Efremov <efremov@linux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Alex Dewar <alex.dewar90@gmail.com>
Cc:     York Sun <york.sun@nxp.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Pete Zaitcev <zaitcev@redhat.com>, linux-edac@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-i3c@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Date:   Sat, 29 Aug 2020 11:23:43 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While doing an investigation for a possible treewide conversion of
sysfs output using sprintf/snprintf/scnprintf, I discovered
several instances of sysfs output without terminating newlines.

It seems likely all of these should have newline terminations
or have the \n\r termination changed to a single newline.

Anyone have any objection to patches adding newlines to these
in their original forms using sprintf/snprintf/scnprintf?

A few of these might be false positives as
	"%s", string
might already have string with a newline termination.

+++ drivers/edac/fsl_ddr_edac.c
+	return sysfs_emit(data, "0x%08x",
+	return sysfs_emit(data, "0x%08x",
+	return sysfs_emit(data, "0x%08x",
+++ drivers/edac/synopsys_edac.c
+	return sysfs_emit(data, "Data Poisoning: %s\n\r",
+		return sysfs_emit(buf, "1");
+		return sysfs_emit(buf, "0");
+		return sysfs_emit(buf, "1");
+		return sysfs_emit(buf, "0");
+		return sysfs_emit(buf, "0");
+		return sysfs_emit(buf, "1");
+		return sysfs_emit(buf, "0");
+	return sysfs_emit(buf, "%u", !!(data->status & mask));
+	return sysfs_emit(buf, "%u", data->tcrit2[index] * 1000);
+	return sysfs_emit(buf, "%d",
+	return sysfs_emit(buf, "%u", data->tcrit1[index] * 1000);
+	return sysfs_emit(buf, "%d",
+	return sysfs_emit(buf, "%d", data->toffset[index] * 500);
+++ drivers/i3c/master.c
+		return sysfs_emit(buf, "i3c:dcr%02Xmanuf%04X", devinfo.dcr,
+	return sysfs_emit(buf, "i3c:dcr%02Xmanuf%04Xpart%04Xext%04X",
+	return sysfs_emit(buf, "%s", dd->boardversion);
+	return sysfs_emit(buf, "%s", dd->serial);
+	return sysfs_emit(buf, "%s", (char *)ib_qib_version);
+	return sysfs_emit(buf, "%s", dd->boardversion);
+	return sysfs_emit(buf, "%s", dd->lbus_info);
+	return sysfs_emit(buf, "ipac:f%02Xv%08Xd%08X", idev->id_format,
+++ drivers/memstick/core/mspro_block.c
+	return sysfs_emit(buffer, "%s", (char *)s_attr->data);
+	return sysfs_emit(buf, "%s",
+	return sysfs_emit(buf, "%s",
+++ drivers/misc/mei/bus.c
+	return sysfs_emit(buf, "%s", cldev->name);
+	return sysfs_emit(buf, "%pUl", uuid);
+	return sysfs_emit(buf, "%02X", version);
+	return sysfs_emit(buf, "mei:%s:%pUl:%02X:",
+	return sysfs_emit(buf, "%d", maxconn);
+	return sysfs_emit(buf, "%d", fixed);
+	return sysfs_emit(buf, "%d", vt);
+	return sysfs_emit(buf, "%u", maxlen);
+	return sysfs_emit(buf, "%s", mei_dev_state_str(dev_state));
+++ drivers/misc/tifm_core.c
+	return sysfs_emit(buf, "%x", sock->type);
+			return sysfs_emit(buf, "%s",
+	return sysfs_emit(buf, "%d", dev->net_count);
+++ drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
+		return sysfs_emit(buf, "%llx",
+		return sysfs_emit(buf, "none");
+++ drivers/net/ethernet/ibm/ehea/ehea_main.c
+	return sysfs_emit(buf, "%d", port->logical_port_id);
+++ drivers/net/wireless/intel/ipw2x00/ipw2200.c
+		return sysfs_emit(buf, "%s", priv->prom_net_dev->name);
+	return sysfs_emit(buf, "0x%04X",
+	return sysfs_emit(buf, "%d", il->retry_rate);
+	return sysfs_emit(buf, "%pOF", np);
+	return sysfs_emit(buf, "pcmcia:m%04Xc%04Xf%02Xfn%02Xpfn%02X"
+++ drivers/platform/x86/dell-smbios-base.c
+		return sysfs_emit(buf, "%08x", da_tokens[i].location);
+		return sysfs_emit(buf, "%08x", da_tokens[i].value);
+	return sysfs_emit(buf, "%08x",
+++ drivers/scsi/st.c
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+	return sysfs_emit(buf, "%lld",
+++ drivers/spi/spi-tle62x0.c
+	return sysfs_emit(buf, "%d", value);
+++ drivers/usb/class/cdc-acm.c
+	return sysfs_emit(buf, "%d", acm->ctrl_caps);
+	return sysfs_emit(buf, "%d", acm->country_rel_date);
+++ drivers/usb/class/usblp.c
+	return sysfs_emit(buf, "%s", usblp->device_id_string+2);
+	return sysfs_emit(buf, "usb:v%04Xp%04Xd%04Xdc%02Xdsc%02Xdp%02X"
+++ drivers/usb/misc/cytherm.c
+	return sysfs_emit(buf, "%i", cytherm->brightness);
+	return sysfs_emit(buf, "%c%i.%i", sign ? '-' : '+', temp >> 1,
+		return sysfs_emit(buf, "1");
+		return sysfs_emit(buf, "0");
+	return sysfs_emit(buf, "%d", retval);
+	return sysfs_emit(buf, "%d", retval);


