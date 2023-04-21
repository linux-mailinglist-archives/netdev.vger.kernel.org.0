Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740DE6EAF2E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbjDUQcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjDUQco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:32:44 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F075126
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:32:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50506ac462bso2756647a12.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682094759; x=1684686759;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2xEKK+IWDwn9+CE2UiVTuzWMnWPoPGhpxxnf2lmN0BM=;
        b=RlxFgFhz+3cVrw2oB207qhBDxwFt3YhouzHUco8ucp7hLrAzahabZaMLVXjuiP9SAw
         JED88vP7crO9tuUDlxg5QVZk53UW1+R114rQ6aNwsz8DazH3zu1J8zfZJc1r72DY136Q
         /mozWEO5F8jovGvbjJGbCq0rJ8NCWVpIzIfRGHQgxn3MsTmnZSVl/z0EhLkIHZJxFv3F
         UeW/iGld1qSjKD9+etIzdc93iYg0BWq/axiPsL12g9WMtRLEIuP9oW4qp2TqvCDgAL4A
         02cHPKGt+R27ejVidP+3hxuv+fGmAZ1GXpyCziYBN2TsWyFarj7v+7ImwTe/ImnCBdjZ
         7vPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682094759; x=1684686759;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xEKK+IWDwn9+CE2UiVTuzWMnWPoPGhpxxnf2lmN0BM=;
        b=g5RM6gPVeXcnfL+S6uNn4mLnvEJpSZ6+jFojQPAN1b2QEuelkWViqjp15E+nhRQ5gg
         39QmmzwCl6VFRJ5rAvHhFAaljeEkupt7W+YXRr4sar8MClbkvTU+iWW+BNQnP/wJj2Fy
         kQ8JqNbbglpOECFiFc1Xhfv87ZByjm9llq45Xf4PjnFS8hlHpiouQIsUU3z/eXgT0pQW
         WFqSUWxWgzR7eM2pcuJ1HgLrbwtBz2Kasm/GLZz410h1/XB+QMDVwz7ShnnX0mvmdyhc
         7Ji+7grLCzuEbt+Rz3GdePgoKNHCCEO1YPYyeab/rIhxTaY++gkHKjwHXMs/A61XGbNy
         IPdQ==
X-Gm-Message-State: AAQBX9epKcvHNIyCIOc+KtXWRCkiHGWNol/qQZwhwLH5KRXFeWtw7anQ
        JQ7/XixL+Z/t757NwXyh3mwdxQ==
X-Google-Smtp-Source: AKy350asCofQRrDL9ByYuVAC23+qU7mGfFIrYsfBuOwtXCD9zUw08y3kOlPbRcMsYP4LR545G6uYWA==
X-Received: by 2002:a17:906:b7c4:b0:94f:17b7:5db3 with SMTP id fy4-20020a170906b7c400b0094f17b75db3mr2990249ejb.20.1682094759454;
        Fri, 21 Apr 2023 09:32:39 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:687d:8c5:41cb:9883? ([2a02:810d:15c0:828:687d:8c5:41cb:9883])
        by smtp.gmail.com with ESMTPSA id f6-20020a17090624c600b0095707b7dd04sm1303356ejb.42.2023.04.21.09.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 09:32:38 -0700 (PDT)
Message-ID: <28fed252-4255-b0d6-4343-f2aeb946f9c6@linaro.org>
Date:   Fri, 21 Apr 2023 18:32:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl
 devicetree compatible
Content-Language: en-US
To:     Rohit Agarwal <quic_rohiagar@quicinc.com>,
        Rob Herring <robh@kernel.org>
Cc:     andersson@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, linus.walleij@linaro.org,
        robh+dt@kernel.org, agross@kernel.org, linux-gpio@vger.kernel.org,
        manivannan.sadhasivam@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, konrad.dybcio@linaro.org,
        devicetree@vger.kernel.org
References: <1682070196-980-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682070196-980-2-git-send-email-quic_rohiagar@quicinc.com>
 <168208107990.922528.1582713033522143366.robh@kernel.org>
 <d4f94878-6c0a-18ee-c1d7-18ae5b56db0c@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <d4f94878-6c0a-18ee-c1d7-18ae5b56db0c@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2023 15:50, Rohit Agarwal wrote:
>=20
> On 4/21/2023 6:26 PM, Rob Herring wrote:
>> On Fri, 21 Apr 2023 15:13:15 +0530, Rohit Agarwal wrote:
>>> Add device tree binding Documentation details for Qualcomm SDX75
>>> pinctrl driver.
>>>
>>> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
>>> ---
>>>   .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 177 ++++++++++=
+++++++++++
>>>   1 file changed, 177 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,s=
dx75-tlmm.yaml
>>>
>> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_che=
ck'
>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>
>> yamllint warnings/errors:
>> ./Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml:76:52=
: [warning] too few spaces after comma (commas)
>>
>> dtschema/dtc warnings/errors:
>> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/binding=
s/pinctrl/qcom,sdx75-tlmm.example.dtb: pinctrl@f100000: uart-w-state: 'on=
eOf' conditional failed, one must be fixed:
>> 	'function' is a required property
>> 	'pins' is a required property
>> 	'rx-pins', 'tx-pins' do not match any of the regexes: 'pinctrl-[0-9]+=
'
>> 	'qup_se1_l2_mira' is not one of ['gpio', 'eth0_mdc', 'eth0_mdio', 'et=
h1_mdc', 'eth1_mdio', 'qlink0_wmss_reset', 'qlink1_wmss_reset', 'rgmii_rx=
c', 'rgmii_rxd0', 'rgmii_rxd1', 'rgmii_rxd2', 'rgmii_rxd3', 'rgmii_rx_ctl=
', 'rgmii_txc', 'rgmii_txd0', 'rgmii_txd1', 'rgmii_txd2', 'rgmii_txd3', '=
rgmii_tx_ctl', 'adsp_ext_vfr', 'atest_char_start', 'atest_char_status0', =
'atest_char_status1', 'atest_char_status2', 'atest_char_status3', 'audio_=
ref_clk', 'bimc_dte_test0', 'bimc_dte_test1', 'char_exec_pending', 'char_=
exec_release', 'coex_uart2_rx', 'coex_uart2_tx', 'coex_uart_rx', 'coex_ua=
rt_tx', 'cri_trng_rosc', 'cri_trng_rosc0', 'cri_trng_rosc1', 'dbg_out_clk=
', 'ddr_bist_complete', 'ddr_bist_fail', 'ddr_bist_start', 'ddr_bist_stop=
', 'ddr_pxi0_test', 'ebi0_wrcdc_dq2', 'ebi0_wrcdc_dq3', 'ebi2_a_d', 'ebi2=
_lcd_cs', 'ebi2_lcd_reset', 'ebi2_lcd_te', 'emac0_mcg_pst0', 'emac0_mcg_p=
st1', 'emac0_mcg_pst2', 'emac0_mcg_pst3', 'emac0_ptp_aux', 'emac0_ptp_pps=
', 'emac1_mcg_pst0', 'emac1_mcg_pst1', 'emac1_mcg_pst2', 'emac1_mcg_pst3'=
, 'emac1_ptp_aux0', 'emac1_ptp_aux1', 'emac1_ptp_aux2', 'emac1_ptp_aux3',=
 'emac1_ptp_pps0', 'emac1_ptp_pps1', 'emac1_ptp_pps2', 'emac1_ptp_pps3', =
'emac_cdc_dtest0', 'emac_cdc_dtest1', 'emac_pps_in', 'ext_dbg_uart', 'gcc=
_125_clk', 'gcc_gp1_clk', 'gcc_gp2_clk', 'gcc_gp3_clk', 'gcc_plltest_bypa=
ssnl', 'gcc_plltest_resetn', 'i2s_mclk', 'jitter_bist_ref', 'ldo_en', 'ld=
o_update', 'm_voc_ext', 'mgpi_clk_req', 'native0', 'native1', 'native2', =
'native3', 'native_char_start', 'native_tsens_osc', 'native_tsense_pwm1',=
 'nav_dr_sync', 'nav_gpio_0', 'nav_gpio_1', 'nav_gpio_2', 'nav_gpio_3', '=
pa_indicator_1', 'pci_e_rst', 'pcie0_clkreq_n', 'pcie1_clkreq_n', 'pcie2_=
clkreq_n', 'pll_bist_sync', 'pll_clk_aux', 'pll_ref_clk', 'pri_mi2s_data0=
', 'pri_mi2s_data1', 'pri_mi2s_sck', 'pri_mi2s_ws', 'prng_rosc_test0', 'p=
rng_rosc_test1', 'prng_rosc_test2', 'prng_rosc_test3', 'qdss_cti_trig0', =
'qdss_cti_trig1', 'qdss_gpio_traceclk', 'qdss_gpio_tracectl', 'qdss_gpio_=
tracedata0', 'qdss_gpio_tracedata1', 'qdss_gpio_tracedata10', 'qdss_gpio_=
tracedata11', 'qdss_gpio_tracedata12', 'qdss_gpio_tracedata13', 'qdss_gpi=
o_tracedata14', 'qdss_gpio_tracedata15', 'qdss_gpio_tracedata2', 'qdss_gp=
io_tracedata3', 'qdss_gpio_tracedata4', 'qdss_gpio_tracedata5', 'qdss_gpi=
o_tracedata6', 'qdss_gpio_tracedata7', 'qdss_gpio_tracedata8', 'qdss_gpio=
_tracedata9', 'qlink0_b_en', 'qlink0_b_req', 'qlink0_l_en', 'qlink0_l_req=
', 'qlink1_l_en', 'qlink1_l_req', 'qup_se0_l0', 'qup_se0_l1', 'qup_se0_l2=
', 'qup_se0_l3', 'qup_se1_l2', 'qup_se1_l3', 'qup_se2_l0', 'qup_se2_l1', =
'qup_se2_l2', 'qup_se2_l3', 'qup_se3_l0', 'qup_se3_l1', 'qup_se3_l2', 'qu=
p_se3_l3', 'qup_se4_l2', 'qup_se4_l3', 'qup_se5_l0', 'qup_se5_l1', 'qup_s=
e6_l0', 'qup_se6_l1', 'qup_se6_l2', 'qup_se6_l3', 'qup_se7_l0', 'qup_se7_=
l1', 'qup_se7_l2', 'qup_se7_l3', 'qup_se8_l2', 'qup_se8_l3', 'sdc1_tb_tri=
g', 'sdc2_tb_trig', 'sec_mi2s_data0', 'sec_mi2s_data1', 'sec_mi2s_sck', '=
sec_mi2s_ws', 'sgmii_phy_intr0', 'sgmii_phy_intr1', 'spmi_coex_clk', 'spm=
i_coex_data', 'spmi_vgi_hwevent', 'tgu_ch0_trigout', 'tri_mi2s_data0', 't=
ri_mi2s_data1', 'tri_mi2s_sck', 'tri_mi2s_ws', 'uim1_clk', 'uim1_data', '=
uim1_present', 'uim1_reset', 'uim2_clk', 'uim2_data', 'uim2_present', 'ui=
m2_reset', 'usb2phy_ac_en', 'vsense_trigger_mirnat']
>> 	'qup_se1_l3_mira' is not one of ['gpio', 'eth0_mdc', 'eth0_mdio', 'et=
h1_mdc', 'eth1_mdio', 'qlink0_wmss_reset', 'qlink1_wmss_reset', 'rgmii_rx=
c', 'rgmii_rxd0', 'rgmii_rxd1', 'rgmii_rxd2', 'rgmii_rxd3', 'rgmii_rx_ctl=
', 'rgmii_txc', 'rgmii_txd0', 'rgmii_txd1', 'rgmii_txd2', 'rgmii_txd3', '=
rgmii_tx_ctl', 'adsp_ext_vfr', 'atest_char_start', 'atest_char_status0', =
'atest_char_status1', 'atest_char_status2', 'atest_char_status3', 'audio_=
ref_clk', 'bimc_dte_test0', 'bimc_dte_test1', 'char_exec_pending', 'char_=
exec_release', 'coex_uart2_rx', 'coex_uart2_tx', 'coex_uart_rx', 'coex_ua=
rt_tx', 'cri_trng_rosc', 'cri_trng_rosc0', 'cri_trng_rosc1', 'dbg_out_clk=
', 'ddr_bist_complete', 'ddr_bist_fail', 'ddr_bist_start', 'ddr_bist_stop=
', 'ddr_pxi0_test', 'ebi0_wrcdc_dq2', 'ebi0_wrcdc_dq3', 'ebi2_a_d', 'ebi2=
_lcd_cs', 'ebi2_lcd_reset', 'ebi2_lcd_te', 'emac0_mcg_pst0', 'emac0_mcg_p=
st1', 'emac0_mcg_pst2', 'emac0_mcg_pst3', 'emac0_ptp_aux', 'emac0_ptp_pps=
', 'emac1_mcg_pst0', 'emac1_mcg_pst1', 'emac1_mcg_pst2', 'emac1_mcg_pst3'=
, 'emac1_ptp_aux0', 'emac1_ptp_aux1', 'emac1_ptp_aux2', 'emac1_ptp_aux3',=
 'emac1_ptp_pps0', 'emac1_ptp_pps1', 'emac1_ptp_pps2', 'emac1_ptp_pps3', =
'emac_cdc_dtest0', 'emac_cdc_dtest1', 'emac_pps_in', 'ext_dbg_uart', 'gcc=
_125_clk', 'gcc_gp1_clk', 'gcc_gp2_clk', 'gcc_gp3_clk', 'gcc_plltest_bypa=
ssnl', 'gcc_plltest_resetn', 'i2s_mclk', 'jitter_bist_ref', 'ldo_en', 'ld=
o_update', 'm_voc_ext', 'mgpi_clk_req', 'native0', 'native1', 'native2', =
'native3', 'native_char_start', 'native_tsens_osc', 'native_tsense_pwm1',=
 'nav_dr_sync', 'nav_gpio_0', 'nav_gpio_1', 'nav_gpio_2', 'nav_gpio_3', '=
pa_indicator_1', 'pci_e_rst', 'pcie0_clkreq_n', 'pcie1_clkreq_n', 'pcie2_=
clkreq_n', 'pll_bist_sync', 'pll_clk_aux', 'pll_ref_clk', 'pri_mi2s_data0=
', 'pri_mi2s_data1', 'pri_mi2s_sck', 'pri_mi2s_ws', 'prng_rosc_test0', 'p=
rng_rosc_test1', 'prng_rosc_test2', 'prng_rosc_test3', 'qdss_cti_trig0', =
'qdss_cti_trig1', 'qdss_gpio_traceclk', 'qdss_gpio_tracectl', 'qdss_gpio_=
tracedata0', 'qdss_gpio_tracedata1', 'qdss_gpio_tracedata10', 'qdss_gpio_=
tracedata11', 'qdss_gpio_tracedata12', 'qdss_gpio_tracedata13', 'qdss_gpi=
o_tracedata14', 'qdss_gpio_tracedata15', 'qdss_gpio_tracedata2', 'qdss_gp=
io_tracedata3', 'qdss_gpio_tracedata4', 'qdss_gpio_tracedata5', 'qdss_gpi=
o_tracedata6', 'qdss_gpio_tracedata7', 'qdss_gpio_tracedata8', 'qdss_gpio=
_tracedata9', 'qlink0_b_en', 'qlink0_b_req', 'qlink0_l_en', 'qlink0_l_req=
', 'qlink1_l_en', 'qlink1_l_req', 'qup_se0_l0', 'qup_se0_l1', 'qup_se0_l2=
', 'qup_se0_l3', 'qup_se1_l2', 'qup_se1_l3', 'qup_se2_l0', 'qup_se2_l1', =
'qup_se2_l2', 'qup_se2_l3', 'qup_se3_l0', 'qup_se3_l1', 'qup_se3_l2', 'qu=
p_se3_l3', 'qup_se4_l2', 'qup_se4_l3', 'qup_se5_l0', 'qup_se5_l1', 'qup_s=
e6_l0', 'qup_se6_l1', 'qup_se6_l2', 'qup_se6_l3', 'qup_se7_l0', 'qup_se7_=
l1', 'qup_se7_l2', 'qup_se7_l3', 'qup_se8_l2', 'qup_se8_l3', 'sdc1_tb_tri=
g', 'sdc2_tb_trig', 'sec_mi2s_data0', 'sec_mi2s_data1', 'sec_mi2s_sck', '=
sec_mi2s_ws', 'sgmii_phy_intr0', 'sgmii_phy_intr1', 'spmi_coex_clk', 'spm=
i_coex_data', 'spmi_vgi_hwevent', 'tgu_ch0_trigout', 'tri_mi2s_data0', 't=
ri_mi2s_data1', 'tri_mi2s_sck', 'tri_mi2s_ws', 'uim1_clk', 'uim1_data', '=
uim1_present', 'uim1_reset', 'uim2_clk', 'uim2_data', 'uim2_present', 'ui=
m2_reset', 'usb2phy_ac_en', 'vsense_trigger_mirnat']
>> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devi=
cetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
>>
>> doc reference errors (make refcheckdocs):
>>
>> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/168=
2070196-980-2-git-send-email-quic_rohiagar@quicinc.com
>>
>> The base for the series is generally the latest rc1. A different depen=
dency
>> should be noted in *this* patch.
>>
>> If you already ran 'make dt_binding_check' and didn't see the above
>> error(s), then make sure 'yamllint' is installed and dt-schema is up t=
o
>> date:
>>
>> pip3 install dtschema --upgrade
>>
>> Please check and re-submit after running the above command yourself. N=
ote
>> that DT_SCHEMA_FILES can be set to your schema file to speed up checki=
ng
>> your schema. However, it must be unset to test all examples with your =
schema.
> Make dt_binding_check not throwing this error even after updating the=20
> dtschema and yamllint is installed.

It does. For both errors. First looks like coming from yamllint so be
sure to have it installed. Second is independent of yamllint and you
should see it.

Best regards,
Krzysztof

