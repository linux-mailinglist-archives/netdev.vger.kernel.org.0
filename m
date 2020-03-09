Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A23D17DF7A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 13:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCIME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 08:04:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43707 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgCIME5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 08:04:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id v9so10727490wrf.10
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 05:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zEiM7K8u2KvOZM51+eTlZdAqX7p3eS4IMtHf8PmMNY8=;
        b=wnSWOV+1On/vn4PM51npvbaYlvfCP+TSaaWhhSlElLSjxc9knrW/ue6xJJMBLkX/Ly
         pWxSj6WyzV/4DAgt1aiMQWyWNkOGrptVqPDFSgQZCHXdwGGXWE7D87sI/nty4zvmxhC6
         HonY1e+5g8p5aCE2ZJx9D0KLPuMIoYWkmCMYYv8QsInhIb6kb4vbURbtEfFB+JJqGnRG
         FS/VUlWmufJIDuVeo4a0pN5TvkHqX0AkZNvgsAnxtGa4DzA7modIw7ilaH+e/y+JH74s
         q8EOQp/cBgrWyFp9qYvX1Pq37k8XYgd7KE6PahfnZ/vwigPWSy40g+uK8SDDZnhYPSfx
         7rmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zEiM7K8u2KvOZM51+eTlZdAqX7p3eS4IMtHf8PmMNY8=;
        b=QFK89AfgCju/RoXI94ElbqevuAVmNQaWCkPc305vBKpPWgZ3FgeJS3WH8c0eZy2XIM
         V2IYriL1dWMD48kBMm5i07slkbtWJ0XBu1macmu8hgUTQqTOG1ueC33FDe4mpARfeCCO
         Uc3tslPbJ7xrWibPaGbLpu+AEjX6AV4dsxoKzDN7n3LcO7Ab9BLI5vSRknRBmTXTvPpN
         sp8eVheSVmx/ZqGL97lp9fTjbaokW5vI5zMFnHLSVzVGfEoWd3EbTqvPGGmsbty+xTIE
         KoZIyoEals2Hl8j1S0lL1elol/C+rrGMNOXlIz6yYpbW0R6W3Q1wSTrGc/4A345F6pS7
         FJJg==
X-Gm-Message-State: ANhLgQ20VCP8Ng1BFR+m9WiTdrEo2B+O4/GRdNtBguuJPIaiNHsOV9Xh
        KB6NtyB9YrOeRS+ghJbQ9wST4g==
X-Google-Smtp-Source: ADFU+vtZXJ789zCyBw4uevYqZIcIVL1l5YE/2X2c6sWS3v135MF3BGBupoPAHhkB072H0KflY8l4og==
X-Received: by 2002:adf:eacf:: with SMTP id o15mr7845413wrn.319.1583755495135;
        Mon, 09 Mar 2020 05:04:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a7sm5935690wrn.25.2020.03.09.05.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 05:04:54 -0700 (PDT)
Date:   Mon, 9 Mar 2020 13:04:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "mlxsw@mellanox.com" <mlxsw@mellanox.com>
Subject: Re: [patch net-next v4 03/10] flow_offload: check for basic action
 hw stats type
Message-ID: <20200309120453.GB13968@nanopsycho.orion>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-4-jiri@resnulli.us>
 <BN8PR12MB3266F1691CDDA4352EFC2684D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266F1691CDDA4352EFC2684D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 11:23:41AM CET, Jose.Abreu@synopsys.com wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Mar/07/2020, 11:40:13 (UTC+00:00)
>
>> Introduce flow_action_basic_hw_stats_types_check() helper and use it
>> in drivers. That sanitizes the drivers which do not have support
>> for action HW stats types.
>
>Next time please cc driver maintainers because this broke L3/L4 selftests 
>for stmmac.

How exactly? This should not have any change for the existing users.


>
>Not to worry, I already have a patch to send :)
>
>---
>Thanks,
>Jose Miguel Abreu
