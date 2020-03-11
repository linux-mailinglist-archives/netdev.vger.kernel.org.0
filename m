Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB31818164C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 11:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgCKKyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 06:54:32 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13714 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgCKKyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 06:54:32 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e68c3380000>; Wed, 11 Mar 2020 03:53:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 11 Mar 2020 03:54:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 11 Mar 2020 03:54:29 -0700
Received: from [10.26.11.218] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Mar
 2020 10:54:26 +0000
Subject: Re: [PATCH v2 15/17] soc: qcom: ipa: support build of IPA code
To:     Alex Elder <elder@linaro.org>, David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
CC:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200306042831.17827-1-elder@linaro.org>
 <20200306042831.17827-16-elder@linaro.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <33e18aa5-5838-a2f2-7112-542a157bd026@nvidia.com>
Date:   Wed, 11 Mar 2020 10:54:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200306042831.17827-16-elder@linaro.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583924025; bh=gKHuKSFbwoxBGV/PyLPT7wPFs57coMnu/jHauOw4skQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=SaE7HfxfinVzma4d1xw/EsHxe6B6/c7qnS0ZKae7TP/YoiG2i/CereBQdwbtNKD25
         0XN9SO7Y+yK7aouZeAlw+Mr15xXKQU9YV1u2zrNm683VfTdhAwBWsxV6TH/gzKqV2v
         o7CAuuclgTTAB7iQS9vGpgNnnJwclyj5WgT/1BqtS7C25pgZBez/v0j4LiszNn7sU4
         14TLc2Owrb8YBTisZMhChWW03Tp0jxCS5kidpBKfHNvFY7aXcOvnZfdLVZQyje+pOV
         Sb8xRdS/pD7MyJvg+ZiMJirNzUWahOJaCAyB4GrJ4koMgzt76A5lTGE4nyjsc2CoOt
         tzoyskRj3cNrQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/03/2020 04:28, Alex Elder wrote:
> Add build and Kconfig support for the Qualcomm IPA driver.
>=20
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/Kconfig      |  2 ++
>  drivers/net/Makefile     |  1 +
>  drivers/net/ipa/Kconfig  | 19 +++++++++++++++++++
>  drivers/net/ipa/Makefile | 12 ++++++++++++
>  4 files changed, 34 insertions(+)
>  create mode 100644 drivers/net/ipa/Kconfig
>  create mode 100644 drivers/net/ipa/Makefile
>=20
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 66e410e58c8e..02565bc2be8a 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -444,6 +444,8 @@ source "drivers/net/fddi/Kconfig"
> =20
>  source "drivers/net/hippi/Kconfig"
> =20
> +source "drivers/net/ipa/Kconfig"
> +
>  config NET_SB1000
>  	tristate "General Instruments Surfboard 1000"
>  	depends on PNP
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index 65967246f240..94b60800887a 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -47,6 +47,7 @@ obj-$(CONFIG_ETHERNET) +=3D ethernet/
>  obj-$(CONFIG_FDDI) +=3D fddi/
>  obj-$(CONFIG_HIPPI) +=3D hippi/
>  obj-$(CONFIG_HAMRADIO) +=3D hamradio/
> +obj-$(CONFIG_QCOM_IPA) +=3D ipa/
>  obj-$(CONFIG_PLIP) +=3D plip/
>  obj-$(CONFIG_PPP) +=3D ppp/
>  obj-$(CONFIG_PPP_ASYNC) +=3D ppp/
> diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
> new file mode 100644
> index 000000000000..b8cb7cadbf75
> --- /dev/null
> +++ b/drivers/net/ipa/Kconfig
> @@ -0,0 +1,19 @@
> +config QCOM_IPA
> +	tristate "Qualcomm IPA support"
> +	depends on ARCH_QCOM && 64BIT && NET
> +	select QCOM_QMI_HELPERS
> +	select QCOM_MDT_LOADER
> +	default QCOM_Q6V5_COMMON
> +	help
> +	  Choose Y or M here to include support for the Qualcomm
> +	  IP Accelerator (IPA), a hardware block present in some
> +	  Qualcomm SoCs.  The IPA is a programmable protocol processor
> +	  that is capable of generic hardware handling of IP packets,
> +	  including routing, filtering, and NAT.  Currently the IPA
> +	  driver supports only basic transport of network traffic
> +	  between the AP and modem, on the Qualcomm SDM845 SoC.
> +
> +	  Note that if selected, the selection type must match that
> +	  of QCOM_Q6V5_COMMON (Y or M).
> +
> +	  If unsure, say N.
> diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
> new file mode 100644
> index 000000000000..afe5df1e6eee
> --- /dev/null
> +++ b/drivers/net/ipa/Makefile
> @@ -0,0 +1,12 @@
> +# Un-comment the next line if you want to validate configuration data
> +#ccflags-y		+=3D	-DIPA_VALIDATE
> +
> +obj-$(CONFIG_QCOM_IPA)	+=3D	ipa.o
> +
> +ipa-y			:=3D	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
> +				ipa_table.o ipa_interrupt.o gsi.o gsi_trans.o \
> +				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
> +				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
> +				ipa_qmi.o ipa_qmi_msg.o
> +
> +ipa-y			+=3D	ipa_data-sdm845.o ipa_data-sc7180.o


This patch is also causing build issues on the current -next ...

  CC [M]  drivers/net/ipa/gsi.o
  In file included from include/linux/build_bug.h:5:0,
                   from include/linux/bitfield.h:10,
                   from drivers/net/ipa/gsi.c:9:
  drivers/net/ipa/gsi.c: In function =E2=80=98gsi_validate_build=E2=80=99:
  drivers/net/ipa/gsi.c:220:39: error: implicit declaration of function =E2=
=80=98field_max=E2=80=99 [-Werror=3Dimplicit-function-declaration]
    BUILD_BUG_ON(GSI_RING_ELEMENT_SIZE > field_max(ELEMENT_SIZE_FMASK));
                                         ^
  include/linux/compiler.h:374:9: note: in definition of macro =E2=80=98__c=
ompiletime_assert=E2=80=99
     if (!(condition))     \
           ^~~~~~~~~
  include/linux/compiler.h:394:2: note: in expansion of macro =E2=80=98_com=
piletime_assert=E2=80=99
    _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
    ^~~~~~~~~~~~~~~~~~~
  include/linux/build_bug.h:39:37: note: in expansion of macro =E2=80=98com=
piletime_assert=E2=80=99
   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                       ^~~~~~~~~~~~~~~~~~
  include/linux/build_bug.h:50:2: note: in expansion of macro =E2=80=98BUIL=
D_BUG_ON_MSG=E2=80=99
    BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
    ^~~~~~~~~~~~~~~~
  drivers/net/ipa/gsi.c:220:2: note: in expansion of macro =E2=80=98BUILD_B=
UG_ON=E2=80=99
    BUILD_BUG_ON(GSI_RING_ELEMENT_SIZE > field_max(ELEMENT_SIZE_FMASK));
    ^~~~~~~~~~~~

Jon=20

--=20
nvpublic
