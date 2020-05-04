Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1E61C45AA
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgEDSTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730105AbgEDSTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:19:16 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B70C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:19:16 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s9so535914qkm.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=M4M+77MtnikkxTuakb851zTjwipFm0VT3gOgKiD/tQE=;
        b=TWLFS6Li6eGggl6A4tjTvD6RoLbhysJ8KY2AnDawrxa+0JQ+CSwLhzcrEpnW5aISfW
         vSO9CMXVOAW++Ovh0i5pBO+ActaZR1D3orZBefEDy38klMa5Q0bKWrobcfJNODhenVfy
         LmOzsDqML0OUqMRl5Jyt0CvTjGZxy5mBnLsBqlDE3VxdZ53mWeyB+re03tFhK9GVBqi9
         kxkLl5qFxN4Qw77ee9KC+2Ntc9cTzOQ9l8O3//xbDu8BJ1M51NCSB2xn1jvQ6fp+iQ19
         idekA/oD0LFC5W6EWkl3fIq1HvEfcvb1xCF/mQJ2PwW+Eu0IFDpNX+sov4AxsYKx3Gkh
         fVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=M4M+77MtnikkxTuakb851zTjwipFm0VT3gOgKiD/tQE=;
        b=Xe9aG5rhwMp7IVSg8R+n2rNMGSHdO6DNJ9adBk5EHVTgtG9VbYT2ZRVk3u3CdiLrKz
         QXFXJFpURCvsPOFa2Ogp7qT/Rp0E0xYE37/cH4GoUK6z6XTIpMPslbTzH7XZZAa6jrJs
         B1iBFPxPIFrazXO19cPT58lOvb7BrCxf15J9gaVP+qxmmAA84zn/VTyhucM0pwrYVNTu
         STX18ZAOzfGtehkCmNdAVSrsO/7tLKUpw21wACk/8me/wqJpiexD5YZPKMno/ExL1wgS
         7C/euJvmQdqhHhXD8svZd5WlVj9ETNM/Fsk90prW6CTWH3zVVrZMYlePXIpXO8QJeK2F
         HCYQ==
X-Gm-Message-State: AGi0PuZxEgtBvBqvKHwYfQhFJuEEEWL6EV5xZomM9PeGNyjcn1WTM4ZI
        79UfXITfAjdtsbmJF3ql7Vo=
X-Google-Smtp-Source: APiQypKjDJOFd9aeIWBvQBPjD1G5Q5tS6GxRGQfva+zX28/6qD6g4BFio8dt5nUEaxMptUkQ2JvN+w==
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr508362qkg.437.1588616355807;
        Mon, 04 May 2020 11:19:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k127sm10508120qkb.35.2020.05.04.11.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 11:19:14 -0700 (PDT)
Date:   Mon, 4 May 2020 14:19:13 -0400
Message-ID: <20200504141913.GB941102@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: Re: [PATCH net-next 4/6] net: dsa: sja1105: support flow-based
 redirection via virtual links
In-Reply-To: <20200503211035.19363-5-olteanv@gmail.com>
References: <20200503211035.19363-1-olteanv@gmail.com>
 <20200503211035.19363-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon,  4 May 2020 00:10:33 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> +		case FLOW_ACTION_REDIRECT: {
> +			struct dsa_port *to_dp;
> +
> +			if (!dsa_slave_dev_check(act->dev)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Destination not a switch port");
> +				return -EOPNOTSUPP;
> +			}
> +
> +			to_dp = dsa_slave_to_port(act->dev);

Instead of exporting two DSA core internal functions, I would rather expose
a new helper for drivers, such as this one:

    struct dsa_port *dsa_dev_to_port(struct net_device *dev)
    {
        if (!dsa_slave_dev_check(dev))
            return -EOPNOTSUPP;
    
        return dsa_slave_to_port(dev);
    }

The naming might not be the best, this helper could even be mirroring-specific,
I didn't really check the requirements for this functionality yet.


Thank you,

	Vivien
